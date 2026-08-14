# The canonical install block

One install story, one wording. `README.md` and every page under `docs/` must say **this** and nothing else. Change it here first, then propagate.

This fork is **not** in Claude Code's official marketplace, so there are two install routes and they are exclusive — always say "pick one".

## Any agent — skills.sh

The skills.sh route works with every coding agent (Claude Code, Codex, and anything else) and writes editable files. Use the whole-set form on `README.md`:

<canonical-block name="skills-sh-whole-set">

```bash
npx skills@latest add ddv12138/mattpocook-skills
```

Pick the skills you want, and which coding agents to install them on. **The installer lets you choose which skills to take — make sure `setup-matt-pocock-skills` is one of them.**

</canonical-block>

…and the single-skill form wherever one skill is named on its own:

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add ddv12138/mattpocook-skills --skill=<name>
```

```bash
npx skills@latest update <name>
```

</canonical-block>

`skills@latest` is the pinned spelling in both.

## Claude Code — the plugin

Not in the official marketplace, so add the fork's own single-plugin marketplace first (`.claude-plugin/marketplace.json`), then install from it:

```
/plugin marketplace add ddv12138/mattpocook-skills
/plugin install mattpocock-skills-cn@mattpocock
```

The plugin is a managed, read-only bundle; updates arrive when the fork ships them.

## The two routes are exclusive

The plugin is a managed, read-only bundle you subscribe to. skills.sh writes files you own and edit. Installing both leaves the user with every skill twice — always say "pick one".
