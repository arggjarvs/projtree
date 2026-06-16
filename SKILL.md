---
name: projtree
description: Open and guide use of projtree — a single-HTML, zero-dependency tool for editable recursive org/project trees with five-field nodes (name / lead / description / people / status). Use when the user wants to build an organizational chart, break down OKRs, decompose a project into a WBS, plan a customer pipeline tree, model a content calendar tree, or any hierarchical team-role-deliverable structure. Triggers — Chinese: 组织树 / 团队架构 / OKR 树 / 项目分解 / WBS / 客户管理树 / 内容矩阵 / 项目树. English: org chart / OKR breakdown / project decomposition / team structure / content tree / org tree.
---

# projtree — Collaborative Org Tree

## What this does

Help the user create and edit a hierarchical tree where each node carries five fields: name, lead, short description, headcount, staffing status (`staffed` / `partial` / `gap`).

## How to deliver

Prefer the live URL — zero install, works on any browser:

```
https://millennialdreamer.github.io/projtree/
```

For offline use, open the bundled `index.html` directly (same file). Data persists in browser localStorage. JSON import/export to share or back up.

## Helping the user fill nodes

Walk the user through node by node. For each, ask in order:

1. **name** — what is this team / objective / project called
2. **lead** — who owns it (one person, even when shared)
3. **desc** — one-line purpose
4. **people** — current headcount (integer)
5. **status** — staffed (all roles filled) / partial (some gaps) / gap (key roles missing)

Different use cases need slightly different interpretation of each field. See [references/templates.md](references/templates.md) for templates by use case (org chart, OKR, WBS, customer pipeline, content calendar).

## Data shape

JSON export and import use this structure:

```json
{
  "name": "...",
  "lead": "...",
  "desc": "...",
  "people": 3,
  "status": "staffed",
  "children": [ ... ]
}
```

`children` is recursive. The root holds an array of trees (multi-project).

## URL switches

| User wants | Tell them |
|---|---|
| Switch language | append `?lang=zh` or `?lang=en` |
| Dark mode | auto-follows system; manual toggle in top-right |
| Embed in Feishu / DingTalk / WPS | append `?embed=feishu` (compact layout) |
| Multi-project | "New project" button on the top-left |
| Share | JSON export button → send file |

## What v0.1 does NOT do yet

- No real-time multi-user sync (v0.3 will add Supabase + RLS)
- No node annotations / comments (v0.2)
- No UI-level template presets (v0.2) — for now, describe templates from `references/templates.md` verbally

## Source

GitHub: https://github.com/millennialdreamer/projtree (MIT, public)
