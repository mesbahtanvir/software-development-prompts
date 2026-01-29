# Initialize PDD in Current Project

**Usage:** `/pdd-init`

Set up PRD Driven Development in the current project by creating the necessary directories and files.

---

## What This Does

1. Creates `docs/prd/` directory for storing PRDs
2. Creates a `CLAUDE.md` file with PDD workflow instructions
3. Optionally creates a starter PRD-000 foundation document

---

## Steps

### Step 1: Check Current State

First, check if PDD is already initialized:

```bash
ls -la docs/prd/ 2>/dev/null || echo "No docs/prd/ directory"
ls CLAUDE.md 2>/dev/null || echo "No CLAUDE.md file"
```

### Step 2: Create Directory Structure

If `docs/prd/` doesn't exist, create it:

```bash
mkdir -p docs/prd
```

### Step 3: Create CLAUDE.md

If `CLAUDE.md` doesn't exist, create it with this content:

```markdown
# CLAUDE.md - Project Instructions

This project follows PRD Driven Development (PDD).

## Core Principle

> **No PRD, No Code**

Every meaningful change must start with a PRD in `docs/prd/`.

## Workflow

1. **Check existing PRDs** in `docs/prd/`
2. **Create a PRD** if one doesn't exist: `/pdd-new`
3. **Reference the PRD** in commits and PRs

## Git Workflow

> **Never push directly to main**

1. Create feature branch: `feat/prd-XXX-short-name`
2. Make commits referencing the PRD
3. Create PR to merge into main

## Commands

- `/pdd-new` — Create a new PRD
- `/pdd-status` — Show PRD dashboard
- `/pdd-features` — Audit implementation
- `/pdd-qa` — Find bugs and quality issues
```

### Step 4: Report Results

**STOP**: Present what was created and confirm:
- "PDD initialized! Created: [list of files/directories]"
- "Run `/pdd-new feature` to create your first PRD."

---

## Constraints

**MUST**:
- Check before overwriting existing files
- Ask before modifying existing CLAUDE.md
- Create minimal, useful starter content

**MUST NOT**:
- Overwrite existing PRDs
- Overwrite CLAUDE.md without confirmation
- Create complex templates that overwhelm new users
