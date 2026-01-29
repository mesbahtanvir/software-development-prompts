# PRD-004: Claude Code Command Integration

**Status:** Draft
**Created:** 2026-01-29

---

## Problem Statement

Users currently have to manually copy prompt content or reference prompt files when working with Claude Code. This creates friction:

1. **Discovery** — Users don't know which prompts exist without checking the repo
2. **Invocation** — Copy-pasting prompts is tedious and error-prone
3. **Arguments** — No way to pass context (PRD number, file paths) to prompts
4. **Workflow** — Switching between reading prompts and executing them breaks flow

The prompts are powerful but underutilized because they're not integrated into the Claude Code workflow.

## Solution

Create Claude Code custom commands (`.claude/commands/*.md`) that wrap each PDD prompt, allowing users to invoke them with slash commands and arguments.

### Command Structure

```
.claude/commands/
├── prd.md              # /prd [type] — Create a new PRD
├── audit-features.md   # /audit-features [prd-number] — Audit feature implementation
├── audit-tests.md      # /audit-tests [prd-number] — Audit test coverage
├── audit-alignment.md  # /audit-alignment — Check PRD vs code alignment
├── audit-ux.md         # /audit-ux — Audit UX issues
├── audit-qa.md         # /audit-qa — Find bugs and quality issues
├── project-setup.md    # /project-setup [stack] — Bootstrap a new project
└── prd-status.md       # /prd-status — Show all PRDs and their status
```

### Example Usage

```bash
# Create a new feature PRD
/prd feature

# Create a bugfix PRD
/prd bugfix

# Audit implementation of PRD-005
/audit-features 005

# Check all PRDs for alignment gaps
/audit-alignment

# Show PRD status dashboard
/prd-status
```

### Argument Passing

Commands accept arguments via `$ARGUMENTS` placeholder:

```markdown
# .claude/commands/audit-features.md

Audit the implementation of PRD-$ARGUMENTS against the codebase.

[Include prompts/core/02-audit-features.md content]
```

## Acceptance Criteria

### AC1: Core Commands Created
- [ ] `/prd` command exists and accepts type argument (feature/bugfix/refactor)
- [ ] `/audit-features` command exists and accepts PRD number
- [ ] `/audit-tests` command exists and accepts PRD number
- [ ] `/audit-alignment` command exists
- [ ] `/audit-ux` command exists
- [ ] `/audit-qa` command exists

### AC2: Utility Commands
- [ ] `/prd-status` command shows all PRDs with status
- [ ] `/project-setup` command accepts stack type argument

### AC3: Argument Handling
- [ ] Commands use `$ARGUMENTS` to accept user input
- [ ] Commands provide sensible defaults when no argument given
- [ ] Commands validate arguments where appropriate

### AC4: Documentation
- [ ] README updated with command usage examples
- [ ] CLAUDE.md updated with available commands
- [ ] Each command file includes brief usage comment

### AC5: Prompt Content
- [ ] Commands include full prompt content (not just references)
- [ ] Commands are self-contained and work standalone
- [ ] Commands follow Claude Code skill format

## Out of Scope

- MCP server integration (future PRD)
- Command autocompletion
- Interactive command builder
- Command versioning

## Technical Notes

### Claude Code Command Format

```markdown
# .claude/commands/command-name.md

Brief description of what this command does.

$ARGUMENTS will be replaced with user input after the slash command.

[Rest of prompt content...]
```

### Directory Structure

Commands go in `.claude/commands/` at repo root. This is the standard Claude Code location for custom commands.

### Prompt Inclusion Strategy

Two options:
1. **Inline** — Copy full prompt content into command file
2. **Reference** — Keep prompts in `prompts/` and reference them

Recommend **inline** for:
- Self-contained commands that work when repo is cloned
- Avoiding broken references
- Allowing command-specific customization

## Success Metrics

1. Users can invoke PDD prompts with single slash command
2. Argument passing works for PRD numbers and types
3. Commands are discoverable via `/help` or similar

---

## Changelog

| Date | Change |
|------|--------|
| 2026-01-29 | PRD created |
