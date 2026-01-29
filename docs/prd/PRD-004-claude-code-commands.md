# PRD-004: Claude Code Command Integration

**Status:** Done
**Created:** 2026-01-29

---

## Problem Statement

Users currently have to manually copy prompt content or reference prompt files when working with Claude Code. This creates friction:

1. **Discovery** — Users don't know which prompts exist without checking the repo
2. **Invocation** — Copy-pasting prompts is tedious and error-prone
3. **Arguments** — No way to pass context (PRD number, file paths) to prompts
4. **Updates** — No way to get latest prompts without manual copying
5. **Per-project setup** — Having to configure each project is tedious

## Solution

Create an npm package that installs PDD commands **globally** to `~/.claude/commands/`, making them available in all projects with a single installation.

### Installation

```bash
# Install globally (one-time setup)
npm install -g pdd

# Or use npx for one-off
npx pdd install
```

### Updates

```bash
# Update to latest version
npm update -g pdd

# Or check and update
pdd update

# Check current version
pdd --version
```

### What Gets Installed

```
~/.claude/
└── commands/
    ├── pdd-help.md         # /pdd-help — Show all PDD commands and usage
    ├── pdd-new.md          # /pdd-new [type] — Create a new PRD
    ├── pdd-init.md         # /pdd-init — Initialize PDD in current project
    ├── pdd-status.md       # /pdd-status — Show all PRDs and status
    ├── pdd-update.md       # /pdd-update — Check for and install updates
    ├── pdd-features.md     # /pdd-features [prd] — Audit implementation
    ├── pdd-tests.md        # /pdd-tests [prd] — Audit test coverage
    ├── pdd-alignment.md    # /pdd-alignment — PRD vs code alignment
    ├── pdd-ux.md           # /pdd-ux — UX audit
    └── pdd-qa.md           # /pdd-qa — Quality audit
```

### Example Usage (After Installation)

```bash
# In any project, these commands are now available:

/pdd-help             # Show all commands and usage
/pdd-new feature      # Create a new feature PRD
/pdd-new bugfix       # Create a bugfix PRD
/pdd-init             # Set up docs/prd/ in current project
/pdd-status           # Show PRD dashboard
/pdd-features 005     # Audit PRD-005 implementation
/pdd-qa               # Find bugs and quality issues
/pdd-update           # Check for updates and install latest
```

## Acceptance Criteria

### AC1: npm Package
- [ ] Package published to npm as `pdd` (or `prd-driven-dev`)
- [ ] `npm install -g pdd` installs commands to `~/.claude/commands/`
- [ ] `npm update -g pdd` updates commands to latest version
- [ ] Package includes version number in installed commands

### AC2: CLI Commands
- [ ] `pdd install` — Install/reinstall commands to ~/.claude/commands/
- [ ] `pdd update` — Check for updates and install if available
- [ ] `pdd --version` — Show installed version
- [ ] `pdd uninstall` — Remove commands from ~/.claude/commands/

### AC3: Slash Commands Created (all prefixed with `pdd-`)
- [ ] `/pdd-help` — Show all PDD commands with descriptions and usage
- [ ] `/pdd-new [type]` — Create PRD (feature/bugfix/refactor)
- [ ] `/pdd-init` — Initialize PDD in current project (creates docs/prd/, CLAUDE.md)
- [ ] `/pdd-status` — Show all PRDs with status
- [ ] `/pdd-update` — Check for updates and run `npm update -g pdd`
- [ ] `/pdd-features [prd]` — Audit feature implementation
- [ ] `/pdd-tests [prd]` — Audit test coverage
- [ ] `/pdd-alignment` — Check PRD vs code alignment
- [ ] `/pdd-ux` — Audit UX issues
- [ ] `/pdd-qa` — Find bugs and quality issues

### AC4: Update Mechanism
- [ ] Commands include version comment for tracking
- [ ] `pdd update` compares installed vs npm version
- [ ] Update preserves user customizations (or warns before overwriting)

### AC5: Documentation
- [ ] README updated with installation instructions
- [ ] `pdd --help` shows usage
- [ ] Each command includes usage comment at top

## Out of Scope

- VS Code extension (future PRD-005)
- MCP server integration (future PRD)
- Per-project installation (only global)
- Auto-update (manual update only)

## Technical Notes

### Package Structure

```
pdd/
├── package.json
├── bin/
│   └── pdd.js           # CLI entry point
├── commands/            # Command templates
│   ├── prd.md
│   ├── prd-init.md
│   ├── audit-features.md
│   └── ...
└── lib/
    ├── install.js       # Copy commands to ~/.claude/commands/
    ├── update.js        # Check and update commands
    └── version.js       # Version management
```

### Version Tracking

Each installed command includes a version comment:

```markdown
<!-- pdd v1.0.0 -->
# /prd — Create a new PRD
...
```

This allows `pdd update` to detect outdated commands.

### Cross-Platform Paths

```javascript
const homeDir = os.homedir();
const claudeCommandsDir = path.join(homeDir, '.claude', 'commands');
```

### /pdd-update Command

The `/pdd-update` command instructs Claude to:
1. Check installed version: `cat ~/.claude/commands/pdd-new.md | grep "pdd v"`
2. Check latest version: `npm view pdd version`
3. If outdated, run: `npm update -g pdd`
4. Report what changed

```markdown
<!-- pdd-update.md -->
Check for PDD command updates.

1. Read the version from ~/.claude/commands/pdd-new.md (look for <!-- pdd vX.X.X -->)
2. Run: npm view pdd version
3. Compare versions
4. If update available, run: npm update -g pdd
5. Report the result
```

## Success Metrics

1. One-command global installation works
2. Commands available in all projects after install
3. `pdd update` successfully updates to latest version
4. Users don't need to configure per-project

---

## Changelog

| Date | Change |
|------|--------|
| 2026-01-29 | PRD created |
| 2026-01-29 | Updated to global installation + npm package |
