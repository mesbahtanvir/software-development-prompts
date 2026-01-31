# PDD Audit Suite

**Usage:** `/pdd-audit <subcommand> [options]`

Run PRD-driven audits on your codebase. All audits start by building a complete understanding of your project from PRDs (Phase 0).

**Subcommand requested:** $ARGUMENTS

---

## Subcommands

| Subcommand | Usage | Description |
|------------|-------|-------------|
| `features` | `/pdd-audit features [prd]` | Find unimplemented or partial PRD features |
| `tests` | `/pdd-audit tests [prd]` | Find test gaps using logical reasoning from PRDs |
| `drift` | `/pdd-audit drift` | Detect code that drifted from PRD specifications |
| `ux` | `/pdd-audit ux` | Find UX issues vs PRD-defined experiences |
| `quality` | `/pdd-audit quality` | Find bugs and code quality issues |
| `ops` | `/pdd-audit ops [focus]` | Security, performance, and devops audit |
| `all` | `/pdd-audit all` | Run all audits in sequence |

---

## Phase 0: Build PRD Context (REQUIRED FOR ALL AUDITS)

Before running ANY audit, you MUST build the complete project understanding:

1. **Discover all PRDs**: Read EVERY file in `docs/prd/`
2. **Build Project Feature Map**: Extract all features, their desired state, and acceptance criteria
3. **Apply resolution rules**: Later PRDs override earlier ones; abandoned PRDs excluded
4. **Construct deterministic view**: The combined "should be" state of the project

See `prompts/core/shared/prd-context-builder.md` for detailed instructions.

**Output the Project Understanding:**

```markdown
## Project Understanding

**PRDs Analyzed:** [count]
**Features Identified:** [count]
**Total Acceptance Criteria:** [count]

### Feature Summary

| Feature | PRD(s) | Status | AC Count |
|---------|--------|--------|----------|
| ... | ... | ... | ... |
```

**STOP**: Present this understanding and ask: "Is this complete? Any PRDs or features I'm missing?"

---

## Route to Subcommand

Based on the first word of `$ARGUMENTS`:

---

### `features` - Find Unimplemented Features

**Usage:** `/pdd-audit features [prd-number]`

Compare the Project Feature Map against actual code to find missing implementations.

**Workflow:**
1. **Phase 0**: Build PRD Context (see above)
2. **Extract features and ACs** from the deterministic view
3. **Search codebase** for each feature implementation
4. **Document status** with file paths and evidence
5. **Generate gap report** with PRD references

**Output Format:**

| Feature | PRD | AC | Status | Evidence |
|---------|-----|----|--------|----------|
| Phone Auth | PRD-007 | AC1 | Not Started | No files found |
| Profile Photo | PRD-002 | AC3 | Partial | Upload exists, no crop |

**All findings MUST reference specific PRDs** (e.g., "PRD-007 AC2: Not implemented")

---

### `tests` - Find Test Gaps (Logical Reasoning)

**Usage:** `/pdd-audit tests [prd-number]`

Use logical reasoning from PRD features to identify critical test gaps - NOT just code coverage metrics.

**Workflow:**
1. **Phase 0**: Build PRD Context (see above)
2. **Build Test Requirements Map** from PRD acceptance criteria
3. **Apply logical reasoning**: What could break? What would hurt users?
4. **Search existing tests** and map to PRD requirements
5. **Identify critical gaps** where business logic is untested

**Output Format:**

```markdown
## Test Requirements Map (from PRDs)

### Feature: [Name] (PRD-XXX)
**Business Criticality:** High
**Acceptance Criteria:**
- PRD-XXX AC1: [Criterion] — Test Required: Yes — Status: UNTESTED
- PRD-XXX AC2: [Criterion] — Test Required: Yes — Status: Covered

**Critical Test Scenarios (Logical Reasoning):**
1. Happy path: [Scenario] — UNTESTED
2. Edge case: [Scenario] — UNTESTED
```

**All findings MUST reference specific PRDs** (e.g., "PRD-007 AC2: No test coverage")

---

### `drift` - Detect Specification Drift

**Usage:** `/pdd-audit drift`

Compare the Authoritative Desired State (from all PRDs) against actual implementation to detect drift.

**Workflow:**
1. **Phase 0**: Build PRD Context (see above)
2. **Construct Authoritative Desired State** from all PRDs
3. **Audit codebase** against each feature specification
4. **Document drift** where implementation differs from spec

**Drift Categories:**
- **Missing**: Feature in PRD but not in code
- **Partial**: Feature exists but incomplete
- **Different**: Feature exists but behaves differently
- **Extra**: Code exists that no PRD describes

**All findings MUST reference specific PRDs** (e.g., "PRD-007 AC2: Implementation differs from spec")

---

### `ux` - User Experience Audit

**Usage:** `/pdd-audit ux`

Evaluate user experience against PRD-defined flows and interactions.

**Workflow:**
1. **Phase 0**: Build PRD Context (see above)
2. **Build UX Requirements Map** from PRD user journeys
3. **Walk through each flow** defined in PRDs
4. **Apply Nielsen's heuristics** and accessibility checks
5. **Document UX gaps** vs PRD specifications

**Output Format:**

```markdown
## UX Requirements Map (from PRDs)

### User Journey: [Name] (PRD-XXX)
**Intended Experience:**
- Step 1: [Action] → [Response]

**UX Issues Found:**
- PRD-XXX AC1: Flow differs from spec - [details]
```

**All findings MUST reference specific PRDs** (e.g., "PRD-002 AC3: Flow differs from spec")

---

### `quality` - Code Quality & Bug Audit

**Usage:** `/pdd-audit quality`

Find bugs, quality issues, and clean code violations using PRD context.

**Workflow:**
1. **Phase 0**: Build PRD Context (see above)
2. **Build Quality Requirements Map** from PRD expected behaviors
3. **Test every feature** against PRD specifications
4. **Apply Clean Code principles** (SOLID, DRY, etc.)
5. **Document bugs** where actual behavior differs from expected

**Bug Categories:**
- **Functional**: Behavior differs from PRD specification
- **Edge Case**: Boundary conditions not handled per PRD
- **Error Handling**: Missing or wrong error responses
- **Code Quality**: Clean code violations, complexity issues

**All findings MUST reference specific PRDs** (e.g., "PRD-007 AC2: Bug - OTP doesn't expire")

---

### `ops` - Operations Audit (Security + Performance + DevOps)

**Usage:** `/pdd-audit ops [focus]`

Where focus is: `security`, `performance`, `devops`, or all three if not specified.

**Workflow:**
1. **Phase 0**: Build PRD Context (see above)
2. **Identify security/performance requirements** from PRDs
3. **Audit based on focus**:
   - **security**: OWASP Top 10, auth/authz, data handling
   - **performance**: Load patterns, caching, query efficiency
   - **devops**: CI/CD, monitoring, deployment, infrastructure
4. **Document findings** with PRD context where applicable

**All findings should reference PRDs where security/performance requirements were specified**

---

### `all` - Run All Audits

**Usage:** `/pdd-audit all`

Run all audit subcommands in sequence, presenting findings after each.

**Sequence:**
1. **Phase 0**: Build PRD Context (ONCE, shared across all)
2. **features**: Find unimplemented features
3. **tests**: Find test gaps
4. **drift**: Detect specification drift
5. **ux**: User experience audit
6. **quality**: Code quality & bugs
7. **ops**: Security, performance, devops

**STOP after each audit** to present findings before proceeding.

---

### If empty or unrecognized subcommand

Show usage help:

```
/pdd-audit - PRD-Driven Audit Suite

All audits start with Phase 0: Build PRD Context

Subcommands:
  features [prd]   Find unimplemented PRD features
  tests [prd]      Find test gaps (logical reasoning from PRDs)
  drift            Detect code drift from specifications
  ux               Find UX issues vs PRD-defined experiences
  quality          Find bugs and code quality issues
  ops [focus]      Security, performance, devops audit
  all              Run all audits in sequence

Examples:
  /pdd-audit features 007
  /pdd-audit tests
  /pdd-audit drift
  /pdd-audit ops security
  /pdd-audit all
```

---

## Constraints

**MUST**:
- Always run Phase 0 (Build PRD Context) before any audit
- Reference specific PRDs in all findings (e.g., "PRD-007 AC2")
- Parse first word of arguments as subcommand
- Show help if subcommand is empty or unrecognized

**MUST NOT**:
- Skip Phase 0 for any audit
- Report findings without PRD references
- Assume implementation matches PRD without verification
