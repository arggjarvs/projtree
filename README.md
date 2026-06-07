# Project Tree (ProjTree)

[中文](./README.zh.md) · **English** · *日本語 (coming v1.0)*

A minimalist single-HTML tool for building **collaborative org trees** — zero deps, double-click to run, Apple-grade UI.

> Outliner tools (Workflowy/Roam/Tana) are personal-note style. Mind-map tools (Xmind/Miro) are draw-style. **Nobody does "collaborative org tree where people, roles, deliverables, and status all hang on nodes" — that's the gap projtree fills.**

## Try it now

**Live demo**: https://arggjarvs.github.io/projtree/

Or just download `index.html` and double-click. Data lives in your browser (localStorage), survives refresh, export to JSON anytime.

![preview](./screenshots/preview.png)

## Features (v0.3)

- **Editable recursive tree** — unlimited depth, full CRUD
- **Multi-project** — start from scratch or import JSON
- **Five-field nodes** — name / lead / description / people / status (staffed / partial / gap)
- **Field-template system** — 6 built-in templates (General · Org Chart · OKR · WBS · Customer Pipeline · Content Calendar) — field labels and status names adapt to the use case; template travels with JSON export as a shared baseline
- **Node annotations** — multi-line notes per node, rendered inline below the description
- **Cloud collaboration** (v0.3) — Email magic link sign-in via Supabase (no Google account required), personal workspace auto-created on first login, invite members via 7-day link, realtime multi-user sync (~300ms), local-first (works offline, syncs in background)
- **Apple aesthetics** — light + auto dark, Liquid Glass topbar, 18px squircle, SF font stack, tabular-nums
- **i18n** — Chinese / Japanese / English, switch on the fly (`?lang=` URL param supported)
- **Persistent** — localStorage primary, Supabase cloud secondary (800ms debounce)
- **JSON import / export** — human-readable, shareable
- **iframe-friendly** — `?embed=feishu/dingtalk/wps` for compact embedded layout

## Install as a Claude Skill

```bash
claude plugin marketplace add arggjarvs/projtree
claude plugin install projtree@arggjarvs-projtree-marketplace
```

Then in any Claude Code / Claude Cowork session just say "build me an OKR tree" / "lay out our team org chart" / "decompose this project into a WBS" — Claude will open projtree and walk you through filling nodes.

## Roadmap

- ✅ **v0.1** — single-HTML MVP, five-field nodes, Apple UI, i18n, localStorage, JSON import/export
- ✅ **v0.2** — field-template system (6 templates) · node annotations · baseline specs in JSON export
- ✅ **v0.3** — Supabase cloud collaboration: email magic link login (no Google account required), workspace, invite link, realtime multi-user sync, local-first offline
- **v1.0** — Feishu / DingTalk / WPS embedded apps, marketplace listings, pricing rollout

## Use cases

OKR breakdown · Org charts · Product requirement trees (WBS) · Knowledge management · Customer pipeline tree · Personal GTD · Team intro pages · Roadmaps

## Cloud setup

> Cloud features are **opt-in**. When `SUPABASE_CONFIG.url` is empty the app runs 100% offline — the Supabase SDK never loads.

See **[SETUP.md](./SETUP.md)** for the Supabase configuration guide.

## Tech stack

Vanilla HTML5 + CSS3 + ES6+ · LocalStorage (primary) · Supabase (optional cloud) · zero build tool · zero bundler

## License

MIT
