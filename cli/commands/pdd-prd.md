# PRD Management

**Usage:** `/pdd-prd <subcommand> [options]`

Manage PRDs (Product Requirements Documents) in your project.

**Subcommand requested:** $ARGUMENTS

---

## Subcommands

| Subcommand | Usage | Description |
|------------|-------|-------------|
| `create` | `/pdd-prd create [type]` | Create a new PRD (feature/bugfix/refactor) |
| `list` | `/pdd-prd list` | List all PRDs and their status |

---

## Route to Subcommand

Based on `$ARGUMENTS`:

### If "create" or "create [type]"

You are a product manager helping create a PRD. Guide the user through an interview to understand their needs and generate a well-structured PRD with specific, testable acceptance criteria.

**Type requested:** (extract type from arguments after "create", if any)

#### Interview Process

**Phase 1: Classify (if type not provided)**

If no type was specified, ask:
> "What type of change is this?"
> 1. **Feature** - New functionality for users
> 2. **Bugfix** - Something is broken and needs fixing
> 3. **Refactor** - Improve code without changing behavior

**STOP**: Wait for user to select type before proceeding.

**Phase 2: Understand the Problem**

**For Features:**
- "What problem does this solve for users?"
- "Who is the target user?"
- "What can't they do today that they need to do?"

**For Bugfixes:**
- "What is the expected behavior?"
- "What is the actual (broken) behavior?"
- "How do you reproduce the bug?"
- "How severe is this? (blocks users / annoying / minor)"

**For Refactors:**
- "What's wrong with the current code?"
- "What will be better after the refactor?"
- "Why is this safe to change now?"

**STOP**: Summarize understanding and ask "Did I capture this correctly?"

**Phase 3: Define the Solution**

Ask:
- "How should this work? Walk me through the experience."
- "Are there any technical constraints or preferences?"
- "What's explicitly NOT part of this change?"

**STOP**: Present solution summary and ask "Any adjustments?"

**Phase 4: Define Acceptance Criteria**

Guide to testable criteria:
> "Let's define exactly how we'll know this is done. Each criterion should be verifiable with a yes/no answer."

**Good criteria:**
- "User can upload files up to 10MB"
- "Error message displays when email format is invalid"

**Bad criteria:**
- "Upload works well" (vague)
- "Better error handling" (not measurable)

**STOP**: Review criteria and ask "Are these complete?"

**Phase 5: Generate PRD**

First, check for the next available PRD number:

```bash
ls docs/prd/
```

Then generate the PRD using the standard template.

**STOP**: Present PRD and ask:
1. "Does this capture everything?"
2. "Ready to save to `docs/prd/PRD-[NUMBER]-[name].md`?"

---

### If "list" or no subcommand

List all PRDs in the project with their status.

```bash
ls docs/prd/
```

Then read each PRD to extract:
- PRD number and title
- Status (Draft, Ready, In Progress, Done, Abandoned)
- Created date

Present as a table:

| PRD | Title | Status | Created |
|-----|-------|--------|---------|
| PRD-001 | ... | Done | ... |

---

### If empty or unrecognized subcommand

Show usage help:

```
/pdd-prd - PRD Management

Subcommands:
  create [type]  Create a new PRD (feature/bugfix/refactor)
  list           List all PRDs and their status

Examples:
  /pdd-prd create feature
  /pdd-prd create bugfix
  /pdd-prd list
```

---

## Constraints

**MUST**:
- Parse the first word of arguments as subcommand
- Route to correct behavior based on subcommand
- Show help if subcommand is empty or unrecognized
- For create: Follow the full interview process
- For list: Show comprehensive PRD status

**MUST NOT**:
- Generate PRD without understanding the problem (for create)
- Accept vague acceptance criteria (for create)
- Skip the out-of-scope section (for create)
