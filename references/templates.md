# Field templates by use case

projtree v0.1 nodes have five fields. Interpret each field differently per use case. v0.2 will add UI presets; for now apply these conventions verbally with the user.

## 1. Organizational chart

- **name** — team / department (e.g. "Frontend Platform")
- **lead** — manager name
- **desc** — one-line mandate (e.g. "Builds shared UI components and design system")
- **people** — current headcount
- **status** — `staffed` (no open roles) / `partial` (1–2 open) / `gap` (≥ 3 open or critical role missing)

## 2. OKR breakdown

- **name** — Objective or Key Result (KR starts with a verb, e.g. "Ship onboarding v2")
- **lead** — single accountable owner (even for team OKRs)
- **desc** — why it matters in one line
- **people** — contributors this quarter
- **status** — `staffed` (on track for ≥ 0.7) / `partial` (at risk, ≤ 0.4) / `gap` (no progress yet)

## 3. WBS (project decomposition)

- **name** — workstream / epic / story
- **lead** — DRI
- **desc** — acceptance criterion in one line
- **people** — committed people
- **status** — `staffed` (kicked off & resourced) / `partial` (identified, not committed) / `gap` (no DRI or resource)

## 4. Customer pipeline tree

- **name** — account or segment
- **lead** — account owner (AM / SDR)
- **desc** — current stage + ACV bucket
- **people** — buying-committee size
- **status** — `staffed` (champion + economic buyer identified) / `partial` (champion only) / `gap` (no champion yet)

## 5. Content calendar tree

- **name** — topic cluster / pillar
- **lead** — editor or DRI
- **desc** — audience + angle in one line
- **people** — contributors for cluster
- **status** — `staffed` (scheduled + assigned) / `partial` (assigned, unscheduled) / `gap` (no owner)

## Choosing status flexibly

When the use case is mixed or domain-specific, ask the user what their health criteria are — projtree keeps `status` intentionally flexible to fit any domain.
