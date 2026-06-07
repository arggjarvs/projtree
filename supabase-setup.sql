-- ===========================================================
-- projtree v0.3 · Supabase 数据库初始化脚本
-- 在 Supabase Dashboard → SQL Editor 中粘贴并运行
-- ===========================================================

-- ---------------------------------------------------------------
-- 1. 表结构
-- ---------------------------------------------------------------

-- 工作区：每个用户注册后自动获得一个个人工作区
CREATE TABLE IF NOT EXISTS public.workspaces (
  id         uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  name       text        NOT NULL,
  owner_id   uuid        NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- 工作区成员（含创建者自身）
CREATE TABLE IF NOT EXISTS public.workspace_members (
  workspace_id uuid NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
  user_id      uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role         text NOT NULL DEFAULT 'editor'
                   CHECK (role IN ('owner','editor')),
  joined_at    timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (workspace_id, user_id)
);

-- 项目（对应 localStorage 里的 project）
CREATE TABLE IF NOT EXISTS public.projects (
  id           uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid        NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
  name         text        NOT NULL,
  template     text        NOT NULL DEFAULT 'default',
  sort_order   integer     NOT NULL DEFAULT 0,
  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now()
);

-- 节点（扁平存储，parent_id 构建树）
CREATE TABLE IF NOT EXISTS public.nodes (
  id          uuid        PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id  uuid        NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  parent_id   uuid        REFERENCES public.nodes(id) ON DELETE CASCADE,
  name        text        NOT NULL DEFAULT '',
  director    text,
  subtitle    text,
  sort_order  integer     NOT NULL DEFAULT 0,
  meta        jsonb       NOT NULL DEFAULT '{}',
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  updated_by  uuid        REFERENCES auth.users(id)
);

-- 邀请令牌（7 天有效，单次使用）
CREATE TABLE IF NOT EXISTS public.invite_tokens (
  token        text        PRIMARY KEY DEFAULT encode(gen_random_bytes(18), 'hex'),
  workspace_id uuid        NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
  role         text        NOT NULL DEFAULT 'editor' CHECK (role IN ('editor')),
  created_by   uuid        NOT NULL REFERENCES auth.users(id),
  used_by      uuid        REFERENCES auth.users(id),
  used_at      timestamptz,
  expires_at   timestamptz NOT NULL DEFAULT now() + interval '7 days',
  created_at   timestamptz NOT NULL DEFAULT now()
);

-- ---------------------------------------------------------------
-- 2. 辅助函数（security definer 避免 RLS 递归）
-- ---------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.is_workspace_member(wid uuid)
RETURNS boolean LANGUAGE sql SECURITY DEFINER STABLE AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.workspace_members
    WHERE workspace_id = wid AND user_id = auth.uid()
  );
$$;

CREATE OR REPLACE FUNCTION public.is_workspace_owner(wid uuid)
RETURNS boolean LANGUAGE sql SECURITY DEFINER STABLE AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.workspace_members
    WHERE workspace_id = wid AND user_id = auth.uid() AND role = 'owner'
  );
$$;

-- 通过 project_id 判断是否是成员（节点层用）
CREATE OR REPLACE FUNCTION public.project_workspace_id(pid uuid)
RETURNS uuid LANGUAGE sql SECURITY DEFINER STABLE AS $$
  SELECT workspace_id FROM public.projects WHERE id = pid;
$$;

-- ---------------------------------------------------------------
-- 3. RLS (Row Level Security)
-- ---------------------------------------------------------------

ALTER TABLE public.workspaces         ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workspace_members  ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects           ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nodes              ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invite_tokens      ENABLE ROW LEVEL SECURITY;

-- workspaces
CREATE POLICY "members see workspace"
  ON public.workspaces FOR SELECT
  USING (public.is_workspace_member(id));

CREATE POLICY "auth users create workspace"
  ON public.workspaces FOR INSERT
  WITH CHECK (owner_id = auth.uid());

CREATE POLICY "owner updates workspace"
  ON public.workspaces FOR UPDATE
  USING (public.is_workspace_owner(id));

CREATE POLICY "owner deletes workspace"
  ON public.workspaces FOR DELETE
  USING (public.is_workspace_owner(id));

-- workspace_members
CREATE POLICY "members see members"
  ON public.workspace_members FOR SELECT
  USING (public.is_workspace_member(workspace_id));

-- 自己可以插入自己（新建工作区 + 接受邀请）
CREATE POLICY "insert self as member"
  ON public.workspace_members FOR INSERT
  WITH CHECK (user_id = auth.uid());

CREATE POLICY "owner removes members"
  ON public.workspace_members FOR DELETE
  USING (public.is_workspace_owner(workspace_id) OR user_id = auth.uid());

-- projects
CREATE POLICY "members see projects"
  ON public.projects FOR SELECT
  USING (public.is_workspace_member(workspace_id));

CREATE POLICY "members create projects"
  ON public.projects FOR INSERT
  WITH CHECK (public.is_workspace_member(workspace_id));

CREATE POLICY "members update projects"
  ON public.projects FOR UPDATE
  USING (public.is_workspace_member(workspace_id));

CREATE POLICY "owner deletes projects"
  ON public.projects FOR DELETE
  USING (public.is_workspace_owner(workspace_id));

-- nodes
CREATE POLICY "members see nodes"
  ON public.nodes FOR SELECT
  USING (public.is_workspace_member(public.project_workspace_id(project_id)));

CREATE POLICY "members create nodes"
  ON public.nodes FOR INSERT
  WITH CHECK (public.is_workspace_member(public.project_workspace_id(project_id)));

CREATE POLICY "members update nodes"
  ON public.nodes FOR UPDATE
  USING (public.is_workspace_member(public.project_workspace_id(project_id)));

CREATE POLICY "members delete nodes"
  ON public.nodes FOR DELETE
  USING (public.is_workspace_member(public.project_workspace_id(project_id)));

-- invite_tokens
CREATE POLICY "owner creates invite"
  ON public.invite_tokens FOR INSERT
  WITH CHECK (public.is_workspace_owner(workspace_id) AND created_by = auth.uid());

CREATE POLICY "members see invites"
  ON public.invite_tokens FOR SELECT
  USING (public.is_workspace_member(workspace_id) OR true);
  -- 注意: 接受邀请的用户还不是成员, 允许 SELECT 所有有效 token

CREATE POLICY "anyone redeems unused token"
  ON public.invite_tokens FOR UPDATE
  USING (used_by IS NULL AND expires_at > now())
  WITH CHECK (used_by = auth.uid());

-- ---------------------------------------------------------------
-- 4. Realtime (允许订阅变更)
-- ---------------------------------------------------------------

ALTER PUBLICATION supabase_realtime ADD TABLE public.projects;
ALTER PUBLICATION supabase_realtime ADD TABLE public.nodes;

-- ---------------------------------------------------------------
-- 5. 触发器：新用户注册时自动建工作区 + 加入为 owner
-- ---------------------------------------------------------------

CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER AS $$
DECLARE
  ws_id uuid;
  display_name text;
BEGIN
  -- 取昵称 (Google OAuth 带 full_name, email fallback)
  display_name := COALESCE(
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'name',
    SPLIT_PART(NEW.email, '@', 1)
  );

  -- 建个人工作区
  INSERT INTO public.workspaces (name, owner_id)
  VALUES (display_name || ' 的工作区', NEW.id)
  RETURNING id INTO ws_id;

  -- 加入为 owner
  INSERT INTO public.workspace_members (workspace_id, user_id, role)
  VALUES (ws_id, NEW.id, 'owner');

  RETURN NEW;
END;
$$;

-- 挂触发器 (幂等)
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ---------------------------------------------------------------
-- 完成！下一步：在 Supabase Dashboard → Authentication → Providers
-- 开启 Google OAuth，填入 Google Cloud Console 的 Client ID 和 Secret
-- ---------------------------------------------------------------
