# PDD Commands Help

Display all available PRD Driven Development commands and their usage.

## Available Commands

| Command | Usage | Description |
|---------|-------|-------------|
| `/pdd-help` | `/pdd-help` | Show this help message |
| `/pdd-new` | `/pdd-new [type]` | Create a new PRD (feature/bugfix/refactor) |
| `/pdd-init` | `/pdd-init` | Initialize PDD in current project |
| `/pdd-status` | `/pdd-status` | Show all PRDs and their status |
| `/pdd-update` | `/pdd-update` | Check for and install command updates |
| `/pdd-features` | `/pdd-features [prd-number]` | Audit feature implementation against PRD |
| `/pdd-tests` | `/pdd-tests [prd-number]` | Audit test coverage against PRD |
| `/pdd-alignment` | `/pdd-alignment` | Check PRD vs code alignment |
| `/pdd-ux` | `/pdd-ux` | Audit UX issues |
| `/pdd-qa` | `/pdd-qa` | Find bugs and quality issues |

## Quick Start

1. **Initialize PDD in your project:**
   ```
   /pdd-init
   ```

2. **Create your first PRD:**
   ```
   /pdd-new feature
   ```

3. **Check PRD status:**
   ```
   /pdd-status
   ```

4. **Run audits:**
   ```
   /pdd-features 001
   /pdd-qa
   ```

## The PDD Cycle

```
Write PRD → Implement → Audit → (gaps become new PRDs)
```

**Core Principle:** No PRD, No Code.

## Learn More

- GitHub: https://github.com/mesbahtanvir/prd-driven-dev
- Update commands: `/pdd-update` or `npm update -g pdd`
