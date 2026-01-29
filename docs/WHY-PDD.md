# Why PRD Driven Development?

PRD Driven Development (PDD) solves a specific problem: **AI coding agents get confused by scattered documentation.**

---

## The Problem

Modern projects have documentation everywhere:
- README.md
- Wiki pages
- Notion docs
- Code comments
- Slack threads
- Jira tickets

When you ask an AI coding agent to "add the user export feature," it might find:
- A README saying "exports are disabled"
- A wiki page describing export formats
- A code comment mentioning "TODO: implement exports"
- A Jira ticket marked "done" for exports

**Which one is true?** The AI doesn't know. It hallucinates, makes assumptions, or asks endless clarifying questions.

---

## The Solution

PDD creates a **deterministic, sequential view** of your project.

### How It Works

1. All project decisions live in numbered PRD files: `PRD-000`, `PRD-001`, `PRD-002`...
2. Reading PRDs in order gives you the complete project state
3. Later PRDs can supersede earlier ones (PRD-005 might update something from PRD-002)

### For AI Agents

When an AI reads your PRDs in sequence:
- It knows exactly what exists
- It knows what's planned vs. done (status field)
- It knows what's out of scope
- No contradictions, no guessing

```
Read PRD-000 → Project foundation
Read PRD-001 → First feature
Read PRD-002 → Second feature
...
Result: Complete, accurate project understanding
```

---

## Who Is PDD For?

### Ideal: Solo Developers

PDD shines for solo developers working with AI assistants:
- You write the PRD
- AI implements it
- No coordination overhead
- Perfect context every time

### Good: Small Teams (2-3 people)

Small teams can use PDD effectively with discipline:
- One person writes the PRD, others implement
- Frequent communication prevents conflicts
- Rebase-only workflow keeps everyone in sync

### Larger Teams

PDD can work for larger teams with workflow adaptations (see below).

---

## Considerations for Teams

### Branch Divergence

The default PDD workflow works best with linear history. Here's the challenge:

```
main (PRD-001, PRD-002, PRD-003)
     ↓
     ├── branch-A creates PRD-004
     └── branch-B creates PRD-005
```

Branch-A doesn't know about PRD-005. Branch-B doesn't know about PRD-004.

If both PRDs affect the same area, you'll have conflicts when merging.

### Parallel Workstreams

With many parallel features, teams may encounter:
- PRD number conflicts
- Branch divergence
- Merge conflicts in PRD files

These aren't limitations of PDD itself—they're workflow considerations. Teams can adapt PDD to their needs with different branching strategies, PRD allocation schemes, or coordination practices.

---

## Mitigation: Linear Branching

The branch divergence problem is significantly reduced with a **rebase-only linear branching model**:

### How It Works

1. Always rebase your branch on main before pushing
2. PRs are merged via rebase (no merge commits)
3. History stays linear: PRD-001 → PRD-002 → PRD-003 → ...

### Benefits

- Branches stay short-lived
- Frequent rebasing catches new PRDs
- Sequential reading remains accurate
- Conflicts surface early, not at merge time

### Workflow

```bash
# Before pushing, always rebase
git fetch origin
git rebase origin/main

# Resolve any PRD conflicts immediately
# Push with updated PRD numbers if needed
```

---

## Summary

| Aspect | PDD Approach |
|--------|--------------|
| **Problem** | AI agents confused by scattered docs |
| **Solution** | Sequential, numbered PRDs |
| **Best for** | Solo devs, small teams |
| **Consideration** | Branch divergence with parallel work |
| **Adaptation** | Rebase-only branching, or customize to your workflow |

---

## Core Principle

> **No PRD, No Code**

Every meaningful change starts with a PRD. The PRD is the source of truth. When in doubt, read the PRDs.
