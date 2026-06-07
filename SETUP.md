# projtree v0.3 · Supabase 云端协作配置教程

五步完成配置，总耗时约 10 分钟。

---

## 第 1 步：创建 Supabase 项目

1. 打开 [https://supabase.com](https://supabase.com) → 登录 → **New project**
2. 填写项目名（如 `projtree`）、数据库密码、选离你最近的区域
3. 等待项目初始化完成（约 1 分钟）

---

## 第 2 步：运行数据库初始化脚本

1. 在 Supabase 控制台左侧菜单 → **SQL Editor**
2. 点击 **New query**
3. 将 `supabase-setup.sql` 全文粘贴进去，点击 **Run**
4. 看到 `Success. No rows returned` 即可

---

## 第 3 步：（已完成）邮件认证默认开启，无需额外配置

Supabase 默认启用 Email 认证，Magic Link 开箱即用，无需任何 OAuth 配置。

- **Site URL** 已通过 API 配置为 `https://arggjarvs.github.io/projtree/`
- **允许的重定向 URL** 已包含本地测试地址 `http://localhost:8742`
- 用户点击登录 → 输入邮箱 → 收到 Magic Link 邮件 → 点击链接完成登录，全程无需 Google 账号

---

## 第 4 步：填入配置到 index.html

在 `index.html` 找到以下代码块（约 700 行处）：

```javascript
const SUPABASE_CONFIG = {
  url: '',   // e.g. 'https://xxxxxxxxxxxx.supabase.co'
  key: '',   // Supabase anon/public key (非 secret key!)
};
```

- `url`：Supabase 控制台 → **Project Settings → API → Project URL**
- `key`：同页面 → **Project API keys → anon / public**（这是公开 key，可以放前端）

填好后保存文件。

---

## 第 5 步：测试

1. 用 `python3 -m http.server 8742` 启动本地服务（或部署到 GitHub Pages）
2. 打开 `http://localhost:8742`，topbar 右侧应出现 **登录** 按钮
3. 点击 → 输入邮箱 → 查收 Magic Link 邮件 → 点击链接完成登录 → 按钮变成已登录状态
4. 点击 **邀请成员** → 复制链接 → 用另一个浏览器打开链接 → 用不同邮箱登录 → 成功加入工作区
5. 两个浏览器同时编辑，变更会在约 300ms 内实时同步

---

## 注意事项

- **纯离线模式**：`SUPABASE_CONFIG.url` 为空时，云端功能完全关闭，Supabase SDK 不会加载，不影响双击本地运行
- **数据迁移**：首次登录时，本地已有数据会自动同步到云端
- **权限模型**：工作区 owner 可邀请成员、删除项目；editor 可新建/编辑/删除节点
- **anon key 安全**：anon key 是公开的，Supabase RLS（行级安全）保护数据，未登录用户只能读取邀请令牌
