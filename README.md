# Project Tree (ProjTree)

[中文](./README.zh.md) · **English** · *日本語 (coming v0.2)*

A minimalist single-HTML tool for building **collaborative org trees** — zero deps, double-click to run, Apple-grade UI.

> Outliner tools (Workflowy/Roam/Tana) are personal-note style. Mind-map tools (Xmind/Miro) are draw-style. **Nobody does "collaborative org tree where people, roles, deliverables, and status all hang on nodes" — that's the gap projtree fills.**

## Try it now

**Live demo**: https://arggjarvs.github.io/projtree/

Or just download `index.html` and double-click. Data lives in your browser (localStorage), survives refresh, export to JSON anytime.

![preview](./screenshots/preview.png)

## Features (v0.1)

- **Editable recursive tree** — unlimited depth, full CRUD
- **Multi-project** — start from scratch or import JSON
- **Five-field nodes** — name / lead / description / people / status (staffed / partial / gap)
- **Apple aesthetics** — light + auto dark, Liquid Glass topbar, 18px squircle, SF font stack, tabular-nums
- **i18n** — Chinese / Japanese / English, switch on the fly (`?lang=` URL param supported)
- **Persistent** — localStorage, no backend needed
- **JSON import / export** — human-readable, shareable
- **iframe-friendly** — `?embed=feishu/dingtalk/wps` for compact embedded layout

## Roadmap

- **v0.2** (1–2 weeks) — node annotations · merge-baseline specs · field-template system (OKR / product / customer / content)
- **v0.3** (3–4 weeks) — Supabase cloud collaboration with **strict RLS from day one**, invite whitelist, 3-tier RBAC, realtime multi-user sync
- **v1.0** (5–8 weeks) — Feishu / DingTalk / WPS embedded apps, marketplace listings, pricing rollout
- **also**: package as a Claude Skill for AI-native distribution

## Use cases

OKR breakdown · Org charts · Product requirement trees (WBS) · Knowledge management · Customer pipeline tree · Personal GTD · Team intro pages · Roadmaps

## Tech stack

Vanilla HTML5 + CSS3 + ES6+ · LocalStorage · zero build · zero dependencies

## License

MIT
