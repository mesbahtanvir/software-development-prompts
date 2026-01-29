# PRD-008: Why PDD Documentation

**Status:** In Progress
**Created:** 2026-01-29

---

## Problem Statement

New users and contributors don't understand why PRD Driven Development exists or when to use it. Without a clear explanation:
- Users don't understand the core problem PDD solves (AI coding agents confused by scattered docs)
- Users don't know if PDD is right for their team size
- Limitations aren't clearly communicated, leading to frustration

## Solution

Create a `docs/WHY-PDD.md` document that explains:

1. **The Problem** — Why scattered documentation fails AI coding agents
2. **The Solution** — How sequential PRD reading creates deterministic project state
3. **Target Audience** — Solo developers and small teams (2-3 people)
4. **Limitations** — Branch divergence issues with parallel workstreams
5. **Mitigations** — How rebase-only linear branching helps teams

## Acceptance Criteria

- [ ] AC1: `docs/WHY-PDD.md` exists
- [ ] AC2: Document explains the problem of scattered documentation for AI agents
- [ ] AC3: Document explains how sequential PRD reading creates deterministic state
- [ ] AC4: Document clearly states target audience (solo devs, small teams)
- [ ] AC5: Document honestly describes the branch divergence limitation
- [ ] AC6: Document explains rebase-only linear branching as a mitigation strategy
- [ ] AC7: Document is linked from main README.md

## Out of Scope

- Tutorials or step-by-step guides (covered in prompts/)
- Comparison with other methodologies
- Enterprise adoption patterns

## Technical Notes

- Keep document concise (under 200 lines)
- Use clear headings for quick scanning
- Include a simple diagram if helpful for understanding

---

## Changelog

| Date | Change |
|------|--------|
| 2026-01-29 | PRD created |
