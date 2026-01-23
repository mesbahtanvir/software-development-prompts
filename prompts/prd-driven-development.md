# PRD-Driven Development Guide
## Simple Product Requirements Documents for Features and Bugs

You are implementing a PRD-first workflow where features and bug fixes have documented requirements before code is merged.

---

## Agentic Workflow

### Phase 1: Setup

- Create `docs/prd/` directory
- Add PRD template
- Update PR template with PRD checklist
- **STOP**: Present setup, ask "Ready to proceed?"

### Phase 2: Create PRDs

- Generate PRD from issue or description
- Use simple template
- Focus on problem and acceptance criteria
- **STOP**: Present PRD, ask "Any changes needed?"

### Phase 3: Integrate

- Link PRD to PR
- Verify acceptance criteria before merge
- Mark PRD as done after merge
- **STOP**: Confirm workflow is working

---

## Constraints

**MUST**:
- Require PRD for features and non-trivial bugs
- Include testable acceptance criteria
- Link PRDs to PRs

**MUST NOT**:
- Merge without linked PRD (unless trivial)
- Create vague acceptance criteria
- Overcomplicate the process

**SHOULD**:
- Keep PRDs short and focused
- Use consistent naming (PRD-001, PRD-002)
- Archive completed PRDs in same folder

---

## Directory Structure

```
project/
├── docs/
│   └── prd/
│       ├── PRD-001-user-auth.md
│       ├── PRD-002-dark-mode.md
│       └── PRD-003-export-csv.md
├── .github/
│   └── PULL_REQUEST_TEMPLATE.md
└── CLAUDE.md
```

Simple. All PRDs in one folder. Status tracked in the document.

---

## PRD Template

```markdown
# PRD-[NUMBER]: [Title]

**Status:** Draft | Approved | Done
**Author:** @username
**Date:** YYYY-MM-DD
**Issue:** #123
**PR:** #456 (added after PR created)

---

## Problem

[What problem are we solving? Who has this problem? Why does it matter?]

---

## Solution

[How will we solve it? Keep it high-level.]

---

## Acceptance Criteria

- [ ] [Specific, testable requirement]
- [ ] [Specific, testable requirement]
- [ ] [Specific, testable requirement]

---

## Out of Scope

- [What we're NOT doing]

---

## Notes

[Technical considerations, risks, dependencies - optional]
```

### Bug PRD Template (Even Simpler)

```markdown
# PRD-[NUMBER]: [Bug Title]

**Status:** Draft | Approved | Done
**Severity:** Critical | High | Medium | Low
**Issue:** #123
**PR:** #456

---

## Bug

**Current:** [What happens now]
**Expected:** [What should happen]
**Steps:** [How to reproduce]

---

## Fix

[Proposed solution]

---

## Acceptance Criteria

- [ ] Bug no longer reproducible
- [ ] [Additional verification]
- [ ] No regression in related features
```

---

## PR Template

```markdown
<!-- .github/PULL_REQUEST_TEMPLATE.md -->

## Description
[What does this PR do?]

## PRD
<!-- Link to PRD or mark as trivial -->
- [ ] **PRD:** [docs/prd/PRD-XXX.md](link)
- [ ] This is a trivial change (no PRD needed)

## Acceptance Criteria
<!-- Copy from PRD -->
- [ ] Criteria 1
- [ ] Criteria 2

## Testing
- [ ] Tests added/updated
- [ ] Manual testing done
```

---

## Claude Skill

```markdown
# /prd

Generate a PRD from an issue or description.

## Instructions

1. Determine next PRD number (check existing PRDs)
2. Create PRD using template
3. Fill in problem, solution, acceptance criteria
4. Save to `docs/prd/PRD-XXX-name.md`

## Keep It Simple

- Problem: 2-3 sentences max
- Solution: 1 paragraph max
- Acceptance criteria: 3-5 items
- Skip optional sections if not needed

## Example

User: "Create PRD for adding Google login"

Output: `docs/prd/PRD-005-google-login.md`
```

---

## Workflow

```
Issue Created
     ↓
Create PRD (if non-trivial)
     ↓
Get PRD Approved (quick review)
     ↓
Create PR → Link PRD
     ↓
Verify Acceptance Criteria
     ↓
Merge → Update PRD Status to "Done"
```

---

## What Needs a PRD?

### Needs PRD
- New features
- Bug fixes affecting users
- UI/UX changes
- API changes

### Skip PRD
- Typo fixes
- Dependency updates
- Documentation
- Internal refactoring
- CI/CD changes

Use `[skip prd]` in PR title for trivial changes.

---

## Naming Convention

```
PRD-[NUMBER]-[short-name].md

PRD-001-user-authentication.md
PRD-002-dark-mode.md
PRD-003-csv-export.md
```

Numbers are sequential. Don't reuse numbers.

---

## CLAUDE.md Addition

```markdown
## PRD Process

Features and bugs need a PRD before merge.

### Commands
- `/prd` - Generate PRD from description

### Location
- PRDs: `docs/prd/`

### Before Coding
1. Check if PRD exists
2. If not, create with `/prd`
3. Link PRD in your PR
```

---

## Checklist

### Setup
- [ ] Create `docs/prd/` directory
- [ ] Update PR template
- [ ] Add `/prd` skill
- [ ] Update CLAUDE.md

### Per Feature/Bug
- [ ] PRD created with acceptance criteria
- [ ] PRD approved
- [ ] PR links to PRD
- [ ] Acceptance criteria verified
- [ ] PRD marked "Done" after merge

---

## Begin

When activated:

1. Check if `docs/prd/` exists
2. Check PR template
3. Ask: "Should I set up the PRD structure?"

Remember: **Keep it simple. A PRD is just problem + solution + acceptance criteria.**
