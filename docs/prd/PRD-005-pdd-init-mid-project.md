# PRD-005: Enhanced pdd-init for Mid-Project Adoption

**Status:** Done
**Created:** 2026-01-29

---

## Problem Statement

Users who adopt PDD in the middle of an existing project currently get an empty `docs/prd/` directory and have to manually figure out what their first PRD should be. The existing codebase, README, and documentation aren't leveraged to create a meaningful starting PRD that captures "what already exists."

This creates friction for mid-project adoption because:
- Users must manually document their existing project state
- There's no automated way to bootstrap PRD-000 from existing artifacts
- The value of PDD isn't immediately visible without a first PRD

## Solution

Enhance `/pdd-init` to automatically analyze the existing project and generate a PRD-000-foundation.md that documents the current state:

1. **Scan existing project artifacts:**
   - README.md — project description, features, usage
   - Config files — package.json, pyproject.toml, Cargo.toml, go.mod, pom.xml, Gemfile, composer.json, etc.
   - `docs/` folder — any existing documentation
   - Code structure — main directories, entry points

2. **Generate PRD-000-foundation.md** containing:
   - Project name and description (from README)
   - Current features (from docs/code analysis)
   - Tech stack (from detected config files)
   - Status marked as "Done" (since it already exists)

3. **Graceful fallback:** If no documentation exists, fall back to current behavior (create structure, prompt user to create PRD manually)

## Acceptance Criteria

- [x] AC1: When `/pdd-init` runs on a project with a README.md, it extracts the project name and description into PRD-000
- [x] AC2: When `/pdd-init` runs, it detects and extracts tech stack from common project config files (e.g., package.json, pyproject.toml, Cargo.toml, go.mod, pom.xml, Gemfile, composer.json, etc.)
- [x] AC3: When `/pdd-init` runs on a project with existing `docs/` folder, it lists discovered documentation in PRD-000
- [x] AC4: The generated PRD-000-foundation.md includes sections: Problem Statement, Current Features, Tech Stack, and Status (marked as "Done")
- [x] AC5: When `/pdd-init` runs on a project with NO documentation or config files, it falls back to current behavior (empty template + prompts user to create PRD manually)
- [x] AC6: Running `/pdd-init` on an already-initialized project (existing `docs/prd/`) does NOT overwrite existing PRDs
- [x] AC7: The analysis is language/framework agnostic — works for any project type

## Out of Scope

- Generating PRDs for future features (use `/pdd-new` for that)
- Deep code analysis or logic understanding (structure only)
- Modifying existing source code
- Automated git commits or branch creation

## Technical Notes

- The command should detect config files by checking for known filenames at the project root
- README parsing should extract the first heading as project name and first paragraph as description
- If multiple config file types exist, include all detected tech stacks
- The generated PRD-000 should be clearly marked as auto-generated with a note to review/edit

---

## Changelog

| Date | Change |
|------|--------|
| 2026-01-29 | PRD created |
| 2026-01-29 | Implementation complete, all ACs verified |
