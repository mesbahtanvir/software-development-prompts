# PRD-016: Command Consolidation

**Status:** Draft
**Created:** 2026-01-31
**Author:** @claude

## Problem Statement

The PDD CLI currently has 19 commands, which is overwhelming for new users and creates maintenance burden. Many commands overlap in functionality (e.g., `find-unimplemented` vs `audit-features`, `find-untested` vs `audit-tests`). Users struggle to know which command to use when.

Additionally, not all commands consistently follow the PDD principle of building a PRD mental model first. Some audit commands jump straight to code analysis without understanding the "desired state" from PRDs.

## Solution

Consolidate 19 commands into ~12 commands using a subcommand structure:

### Current Commands (19)

```
/pdd-init, /pdd-prd-create, /pdd-prd-list
/pdd-find-unimplemented, /pdd-find-untested, /pdd-find-drift
/pdd-audit-features, /pdd-audit-tests, /pdd-audit-alignment
/pdd-audit-ux, /pdd-audit-qa, /pdd-audit-security
/pdd-audit-performance, /pdd-audit-devops, /pdd-audit-all
/pdd-help, /pdd-upgrade, /pdd-clean-code, /pdd-setup
```

### Proposed Commands (12)

| Command | Subcommands | Description |
|---------|-------------|-------------|
| `/pdd-init` | - | Initialize PDD in a project |
| `/pdd-prd` | `create`, `list` | PRD management |
| `/pdd-audit` | `features`, `tests`, `drift`, `ux`, `quality`, `ops`, `all` | All auditing functions |
| `/pdd-help` | - | Show help and command reference |
| `/pdd-upgrade` | - | Upgrade PDD to latest version |

### Command Mapping

| Old Command | New Command |
|-------------|-------------|
| `/pdd-prd-create` | `/pdd-prd create` |
| `/pdd-prd-list` | `/pdd-prd list` |
| `/pdd-find-unimplemented` | `/pdd-audit features` |
| `/pdd-find-untested` | `/pdd-audit tests` |
| `/pdd-find-drift` | `/pdd-audit drift` |
| `/pdd-audit-features` | `/pdd-audit features` |
| `/pdd-audit-tests` | `/pdd-audit tests` |
| `/pdd-audit-alignment` | `/pdd-audit drift` |
| `/pdd-audit-ux` | `/pdd-audit ux` |
| `/pdd-audit-qa` | `/pdd-audit quality` |
| `/pdd-audit-security` | `/pdd-audit ops` |
| `/pdd-audit-performance` | `/pdd-audit ops` |
| `/pdd-audit-devops` | `/pdd-audit ops` |
| `/pdd-audit-all` | `/pdd-audit all` |
| `/pdd-clean-code` | `/pdd-audit quality` |
| `/pdd-setup` | `/pdd-init` |

### PRD-Oriented Design

All audit commands MUST follow the PDD principle:

1. **Phase 0: Build PRD Context** - Read ALL PRDs first to build the deterministic view
2. **Mental Model First** - Understand "desired state" before analyzing code
3. **PRD References** - All findings must reference specific PRDs (e.g., "PRD-007 AC2")

This applies to ALL audit subcommands:

- `features` - Compare PRD features vs implemented code
- `tests` - Use logical reasoning from PRDs to find test gaps
- `drift` - Detect code drift from PRD specifications
- `ux` - Evaluate UX against PRD-defined flows
- `quality` - Find bugs using PRD context for expected behavior
- `ops` - Security/performance/devops audits with PRD awareness

### Deprecation Strategy

Old commands will show migration messages for 2 versions:

```
⚠️  /pdd-find-unimplemented is deprecated.
   Use: /pdd-audit features

   This command will be removed in v3.0
```

## Acceptance Criteria

- [ ] AC1: Total commands reduced from 19 to 12 (or fewer)
- [ ] AC2: All audit commands start with Phase 0 (Build PRD Context)
- [ ] AC3: `/pdd-audit` accepts subcommands: features, tests, drift, ux, quality, ops, all
- [ ] AC4: `/pdd-prd` accepts subcommands: create, list
- [ ] AC5: Deprecated commands show migration message pointing to new command
- [ ] AC6: All functionality preserved (nothing removed, only consolidated)
- [ ] AC7: Help command updated to reflect new structure
- [ ] AC8: Each audit subcommand references `prompts/core/shared/prd-context-builder.md`
- [ ] AC9: `/pdd-audit ops` combines security, performance, and devops audits
- [ ] AC10: `/pdd-audit all` runs all audit subcommands in sequence

## Out of Scope

- Adding new functionality (this is consolidation only)
- Changing the underlying prompt content (except to ensure Phase 0)
- Breaking changes to prompt output format

## Technical Notes

### Implementation Approach

1. Update CLI to use subcommand parsing
2. Create wrapper that routes to correct prompt
3. Add deprecation warnings to old command handlers
4. Update help system to show new structure

### File Changes

- `cli/commands/` - Add new consolidated command handlers
- `cli/commands/deprecated/` - Move old commands with warnings
- `prompts/core/` - Ensure all audit prompts reference shared context builder
- `README.md` - Update command documentation
- `docs/why-pdd.md` - Update command examples

## Dependencies

- PRD-015: PRD Context-Aware Audits (provides Phase 0 foundation)
