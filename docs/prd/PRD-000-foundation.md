# PRD-000: PRD Driven Development Foundation

**Status:** Done
**Created:** 2026-01-29
**Author:** System Bootstrap

---

## Problem Statement

Software projects frequently suffer from:
- **Scope creep** - Features grow beyond original intent without explicit decisions
- **Implementation drift** - Code diverges from requirements over time
- **Knowledge loss** - Why decisions were made gets forgotten
- **Quality gaps** - Testing and UX considerations come as afterthoughts
- **AI collaboration friction** - LLMs need clear context to be effective partners

Developers jump straight to code without documenting intent, making it impossible to:
1. Verify if implementation matches requirements
2. Onboard new team members (human or AI)
3. Audit quality systematically
4. Maintain consistency across features

## Solution

**PRD Driven Development (PDD)** - A methodology where every meaningful change starts with a Product Requirements Document.

### Core Principle
> **No PRD, No Code**

### The PDD Cycle

```
┌─────────────────────────────────────────────────────────┐
│                    PDD CYCLE                            │
│                                                         │
│    ┌──────────┐     ┌──────────┐     ┌──────────┐      │
│    │  Write   │────▶│Implement │────▶│  Audit   │      │
│    │   PRD    │     │   Code   │     │  Gaps    │      │
│    └──────────┘     └──────────┘     └────┬─────┘      │
│         ▲                                  │            │
│         │                                  │            │
│         └──────────────────────────────────┘            │
│              (gaps become new PRDs)                     │
└─────────────────────────────────────────────────────────┘
```

### What This Repository Provides

A complete prompt library for AI-assisted PDD:

| Category | Purpose |
|----------|---------|
| **Core** | PDD methodology, audit workflows (features, tests, alignment, UX, QA) |
| **Implement** | Project setup, clean code, testing, security/performance |
| **Reference** | API design, cloud infrastructure, production checklist |

## Current State (as of PRD-000)

### Existing Assets

```
prompts/
├── core/                    # 6 prompts - PDD workflow
│   ├── 01-pdd-methodology   # Defines the methodology
│   ├── 02-audit-features    # Find unimplemented features
│   ├── 03-audit-tests       # Find missing tests
│   ├── 04-audit-alignment   # PRD vs code alignment
│   ├── 05-audit-ux          # UX/product critique
│   └── 06-audit-qa          # Bugs and quality issues
├── implement/               # 4 prompts - Build support
│   ├── project-setup        # Bootstrap projects
│   ├── clean-code           # Refactoring
│   ├── testing              # Test strategies
│   └── security-performance # Security & perf audits
└── reference/               # 3 prompts - Deep guides
    ├── api-design           # API best practices
    ├── cloud-infrastructure # Deployment patterns
    └── production-checklist # Launch readiness
```

### What's Missing

1. **PRD Creation Prompt** - Interactive prompt to generate PRDs through guided questions
2. **Claude Code Integration** - CLAUDE.md wiring prompts as project commands
3. **Workflow Orchestrator** - "Start here" entry point for new users
4. **PRD Templates** - Structured templates for different PRD types (feature, bugfix, refactor)

## Acceptance Criteria

### AC1: PRD Creation Prompt
- [ ] Prompt asks clarifying questions about the feature/change
- [ ] Generates PRD following standard template
- [ ] Includes problem statement, solution, and testable acceptance criteria
- [ ] Suggests appropriate PRD number and filename
- [ ] Works for features, bugfixes, and refactors

### AC2: Claude Code Integration
- [ ] CLAUDE.md exists with project context
- [ ] Documents how to use prompts in Claude Code workflow
- [ ] Defines when to use which prompt
- [ ] Includes PDD workflow instructions

### AC3: Self-Hosting PDD
- [ ] This repository uses PDD for its own development
- [ ] All future changes reference a PRD
- [ ] PRDs stored in `docs/prd/`
- [ ] README updated to reflect PDD self-hosting

### AC4: Prompt Quality Bar
- [ ] All prompts follow consistent structure
- [ ] Each prompt has clear phases with STOP points
- [ ] Constraints defined (MUST/MUST NOT/SHOULD)
- [ ] Examples and templates embedded
- [ ] Works with any tech stack

## Out of Scope

- Web UI for PRD management
- PRD storage/database system
- Version control integration beyond git
- Multi-user collaboration features
- PRD approval workflows

## Technical Notes

### PRD Naming Convention
```
PRD-{number}-{short-name}.md

Examples:
- PRD-000-foundation.md
- PRD-001-prd-creation-prompt.md
- PRD-002-claude-integration.md
```

### PRD Status Values
- `Draft` - Work in progress
- `Ready` - Ready for implementation
- `In Progress` - Being implemented
- `Done` - Implemented and verified
- `Abandoned` - Decided not to implement

## Success Metrics

1. Every PR references a PRD
2. Audit prompts find minimal gaps after implementation
3. New contributors can understand project intent from PRDs alone
4. AI assistants can effectively implement features from PRD context

---

## Changelog

| Date | Change |
|------|--------|
| 2026-01-29 | PRD-000 created - bootstrapping PDD in this repository |
