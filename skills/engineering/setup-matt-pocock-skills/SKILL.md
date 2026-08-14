---
name: setup-matt-pocock-skills
description: Configure this repo for the engineering skills — set up its issue tracker, triage label vocabulary, domain doc layout, and output language. Run once before first use of the other engineering skills.
disable-model-invocation: true
---

# Setup Matt Pocock's Skills

Scaffold the per-repo configuration that the engineering skills assume:

- **Issue tracker** — where issues live (GitHub by default; local markdown is also supported out of the box)
- **Triage labels** — the strings used for the five canonical triage roles
- **Domain docs** — where `CONTEXT.md` and ADRs live, and the consumer rules for reading them
- **Output language** — the language the generated files and this repo's skill outputs are written in (English by default; Chinese on request)

This is a prompt-driven skill, not a deterministic script. Explore, present what you found, confirm with the user, then write.

## Process

### 1. Explore

Look at the current repo to understand its starting state. Read whatever exists; don't assume:

- `git remote -v` and `.git/config` — is this a GitHub repo? Which one?
- `AGENTS.md` and `CLAUDE.md` at the repo root — does either exist? Is there already an `## Agent skills` section in either?
- `CONTEXT.md` and `CONTEXT-MAP.md` at the repo root
- `docs/adr/` and any `src/*/docs/adr/` directories
- `docs/agents/` — does this skill's prior output already exist? If so, note the language its prose is written in: Chinese prose means the repo's language is already chosen (skip Section 0); English or absent means ask.
- `.scratch/` — sign that a local-markdown issue tracker convention is already in use
- Is the `triage` skill installed? (a `triage` skill folder alongside this one, or `triage` in your available skills.) This decides whether Section B runs at all.
- Monorepo signals — a `pnpm-workspace.yaml`, a `workspaces` field in `package.json`, or a populated `packages/*` with its own `src/`. Present only in a genuinely large multi-package repo; their absence means single-context, which is almost every repo.

### 2. Present findings and ask

Summarise what's present and what's missing. Then take the sections in order — one section, one answer, then the next.

Lead each section with the recommended answer so the user can accept it in a word. Give a one-line explainer only when the choice genuinely branches; skip the section entirely when exploration already settled it (Section B when `triage` isn't installed, Section C when there's no monorepo).

**Section 0 — Language.** Ask this first; it shapes every artifact you write. Skip it on re-runs when exploration found the existing `docs/agents/*.md` files already written in Chinese.

One question, three options:

- **全中文 — Chinese, label values included**: every generated file and the `## Agent skills` block are written in Chinese; the tracker's label values (the five triage roles and the wayfinder map/type labels) become Chinese strings recorded as an authoritative label table; the block gains an output-language line.
- **中文，标签值保留英文 — Chinese, English label values** *(recommended)*: generated files, the block and the output-language line are written in Chinese; label values stay the English tokens.
- **英文 — English**: the original behaviour — nothing changes.

For either Chinese option, translate the seed templates' prose into Chinese and keep every command, code span, path, URL and label token verbatim.

Suggested Chinese label values (propose these in the 全中文 tier; the user may adjust):

| Role / token | English default | Suggested Chinese |
| --- | --- | --- |
| `needs-triage` | `needs-triage` | `待分类` |
| `needs-info` | `needs-info` | `待补充信息` |
| `ready-for-agent` | `ready-for-agent` | `可代理执行` |
| `ready-for-human` | `ready-for-human` | `需人工处理` |
| `wontfix` | `wontfix` | `不处理` |
| wayfinder map | `wayfinder:map` | `导航:地图` |
| wayfinder type | `wayfinder:research` / `prototype` / `grilling` / `task` | `导航:调研` / `导航:原型` / `导航:追问` / `导航:任务` |

**Section A — Issue tracker.**

> Explainer: The "issue tracker" is where issues live for this repo. Skills like `to-tickets`, `triage`, and `to-spec` read from and write to it — they need to know whether to call `gh issue create`, write a markdown file under `.scratch/`, or follow some other workflow you describe. Pick the place you actually track work for this repo.

Default posture: these skills were designed for GitHub. If a `git remote` points at GitHub, propose that. If a `git remote` points at GitLab (`gitlab.com` or a self-hosted host), propose GitLab. Otherwise (or if the user prefers), offer:

- **GitHub** — issues live in the repo's GitHub Issues (uses the `gh` CLI)
- **GitLab** — issues live in the repo's GitLab Issues (uses the [`glab`](https://gitlab.com/gitlab-org/cli) CLI)
- **Local markdown** — issues live as files under `.scratch/<feature>/` in this repo (good for solo projects or repos without a remote)
- **Other** (Jira, Linear, etc.) — ask the user to describe the workflow in one paragraph; the skill will record it as freeform prose

Record the choice in `docs/agents/issue-tracker.md`. The GitHub and GitLab templates carry a "PRs as a request surface" flag, defaulted **off** — leave it off and don't raise it; a user who wants external PRs in the triage queue can flip the flag in the file later.

**Section B — Triage label vocabulary.** Skip this section entirely if the `triage` skill isn't installed (exploration told you) — an uninstalled skill needs no labels.

If it is installed, ask exactly one question:

> Do you want to keep the default triage labels? (recommended: **yes**)

The defaults are the five canonical roles, each label string equal to its name: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. On **yes**, write them as-is. Only if the user says no — usually because their tracker already uses other names (e.g. `bug:triage` for `needs-triage`) — collect the overrides so `triage` applies existing labels instead of creating duplicates.

In the 全中文 tier the proposed defaults are Section 0's Chinese strings (`待分类`, `待补充信息`, `可代理执行`, `需人工处理`, `不处理`) instead of the English names; on **yes**, write those. The override question works the same either way.

**Section C — Domain docs.** Default to **single-context** — one `CONTEXT.md` + `docs/adr/` at the repo root. This fits almost every repo; write it without asking.

Offer **multi-context** — a root `CONTEXT-MAP.md` pointing to per-context `CONTEXT.md` files — only when exploration found monorepo signals. Then confirm which layout they want.

### 3. Confirm and edit

Show the user a draft of:

- The `## Agent skills` block to add to whichever of `CLAUDE.md` / `AGENTS.md` is being edited (see step 4 for selection rules)
- The contents of `docs/agents/issue-tracker.md`, `docs/agents/domain.md`, and `docs/agents/triage-labels.md` (the last only when `triage` is installed)
- For a Chinese tier, the drafts are written in Chinese and include the output-language line (and, in the 全中文 tier, the Chinese label values from Section 0)

Let them edit before writing.

### 4. Write

**Pick the file to edit:**

- If `CLAUDE.md` exists, edit it.
- Else if `AGENTS.md` exists, edit it.
- If neither exists, ask the user which one to create — don't pick for them.

Never create `AGENTS.md` when `CLAUDE.md` already exists (or vice versa) — always edit the one that's already there.

If an `## Agent skills` block already exists in the chosen file, update its contents in-place rather than appending a duplicate. Don't overwrite user edits to the surrounding sections.

The block:

```markdown
## Agent skills

### Issue tracker

[one-line summary of where issues are tracked]. See `docs/agents/issue-tracker.md`.

### Triage labels

[one-line summary of the label vocabulary]. See `docs/agents/triage-labels.md`.

### Domain docs

[one-line summary of layout — "single-context" or "multi-context"]. See `docs/agents/domain.md`.
```

Include the `### Triage labels` sub-block, and write `docs/agents/triage-labels.md`, only when `triage` is installed and Section B ran. When it isn't, both are omitted.

**Write everything in the chosen language.** For either Chinese tier, the `## Agent skills` block and the `docs/agents/*.md` files are written in Chinese — translate the seed templates' narrative, keep commands, code, paths, URLs and label tokens verbatim. Add an **output-language line** to the block, in the chosen language, stating that all skill outputs, summaries and reports for this repo are written in Chinese (e.g. `### 输出语言` / "本项目所有技能输出、总结、报告请使用中文。").

For the **全中文 tier**, additionally write the label values as Chinese — the right-hand column of `triage-labels.md` and the map/type labels in the issue-tracker's Wayfinding section — using Section 0's suggested values unless the user adjusted them, and append an override note to the tracker file: *this repo's label values are authoritative; English tokens in skill bodies (e.g. `wayfinder:map`, `ready-for-agent`) are defaults only — create and query labels with this repo's values.* Before writing, probe the tracker for existing issues bearing the English labels (`glab issue list --label ...` / `gh issue list --label ...`); if any exist, tell the user and let them choose between re-labelling the existing issues or keeping the English values.

Then write the docs files using the seed templates in this skill folder as a starting point:

- [issue-tracker-github.md](./issue-tracker-github.md) — GitHub issue tracker
- [issue-tracker-gitlab.md](./issue-tracker-gitlab.md) — GitLab issue tracker
- [issue-tracker-local.md](./issue-tracker-local.md) — local-markdown issue tracker
- [triage-labels.md](./triage-labels.md) — label mapping (only if `triage` is installed)
- [domain.md](./domain.md) — domain doc consumer rules + layout

For "other" issue trackers, write `docs/agents/issue-tracker.md` from scratch using the user's description.

### 5. Done

Tell the user the setup is complete and which engineering skills will now read from these files. Mention they can edit `docs/agents/*.md` directly later — re-running this skill is only necessary if they want to switch issue trackers or restart from scratch. For a Chinese tier, mention the output-language line in the block; editing that line or the docs files is how they change the language later.
