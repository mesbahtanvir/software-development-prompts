# Build a Production Webapp from Scratch

A step-by-step guide using the prompts in this repository to build a complete, production-ready web application.

---

## Philosophy

This guide follows a **PRD-first, skills-enabled** approach:

1. **Foundation** - Set up PRD system and Claude skills before writing code
2. **Plan** - Create PRD for initial features before implementation
3. **Build** - Use specialized prompts for each development phase
4. **Ship** - Comprehensive testing, security, and deployment

This ensures every feature is documented, tracked, and built with consistent quality.

---

## Prerequisites

- Claude Code CLI installed
- Node.js 20+, Python 3.11+
- Git, GitHub account
- Firebase CLI (`npm i -g firebase-tools`)

---

## The Sequence

```
Phase 1: Foundation
├── Step 1: Initialize empty project
├── Step 2: Set up PRD system
└── Step 3: Set up Claude skills

Phase 2: Planning
├── Step 4: Create PRD for authentication
├── Step 5: Create PRD for core features
└── Step 6: Review and approve PRDs

Phase 3: Setup
├── Step 7: Bootstrap project structure
├── Step 8: Configure Firebase
└── Step 9: Set up CI/CD

Phase 4: Implementation
├── Step 10: Implement authentication
├── Step 11: Implement core features
└── Step 12: Build UI components

Phase 5: Quality
├── Step 13: Write tests
├── Step 14: Security audit
└── Step 15: Performance check

Phase 6: Launch
├── Step 16: Final review
├── Step 17: Deploy
└── Step 18: Post-launch monitoring
```

---

## Phase 1: Foundation

### Step 1: Initialize Empty Project

Create the basic project structure manually:

```bash
mkdir my-webapp && cd my-webapp
git init

# Create essential directories
mkdir -p docs/prd .claude/skills

# Create CLAUDE.md (project context for Claude)
touch CLAUDE.md

# Create gitignore
cat > .gitignore << 'EOF'
node_modules/
venv/
.env
.env.local
*.key
.DS_Store
EOF

git add . && git commit -m "chore: initial project structure"
```

### Step 2: Set Up PRD System

**Prompt:** [`prompts/prd-driven-development.md`](prompts/prd-driven-development.md)

```
Using the prd-driven-development prompt, set up the PRD system for this project:

1. Create the docs/prd/ directory structure
2. Add the PRD template
3. Create .github/PULL_REQUEST_TEMPLATE.md with PRD checklist
4. Update CLAUDE.md with PRD workflow documentation

This project will be a webapp with:
- User authentication (email, Google)
- User dashboard
- [Your core feature]
```

**What this creates:**
- `docs/prd/` directory
- PRD template file
- PR template with PRD checklist
- CLAUDE.md PRD section

### Step 3: Set Up Claude Skills

**Prompt:** [`prompts/claude-code-skills-setup.md`](prompts/claude-code-skills-setup.md)

```
Using the claude-code-skills-setup prompt, create skills for this webapp project:

Skills needed:
1. /prd - Generate PRDs from descriptions
2. /component - Generate React components
3. /api - Generate API endpoints
4. /test - Generate tests
5. /review - Code review checklist

Tech stack:
- Frontend: Next.js 15, TypeScript, Tailwind, Shadcn/UI
- Backend: Python FastAPI
- Database: Firebase Firestore
- Auth: Firebase Authentication
```

**What this creates:**
- `.claude/skills/prd/skill.md`
- `.claude/skills/component/skill.md`
- `.claude/skills/api/skill.md`
- `.claude/skills/test/skill.md`
- `.claude/skills/review/skill.md`

---

## Phase 2: Planning

### Step 4: Create PRD for Authentication

Use your new `/prd` skill:

```
/prd

Create PRD-001 for user authentication:

Problem: Users need to sign up and sign in to access the application.

Features:
- Email/password signup and login
- Google OAuth login
- Password reset flow
- Protected routes
- Session persistence

This is the foundation for all user-specific features.
```

**Output:** `docs/prd/PRD-001-user-authentication.md`

### Step 5: Create PRD for Core Features

```
/prd

Create PRD-002 for user dashboard:

Problem: Authenticated users need a home base to see their data and navigate the app.

Features:
- Welcome message with user name
- Summary statistics cards
- Quick action buttons
- Recent activity feed
- Navigation to settings
```

**Output:** `docs/prd/PRD-002-user-dashboard.md`

Continue creating PRDs for each major feature before writing any implementation code.

### Step 6: Review and Approve PRDs

Before proceeding, review each PRD:

```
Review all PRDs in docs/prd/:

For each PRD, verify:
1. Problem statement is clear
2. Solution is feasible
3. Acceptance criteria are testable
4. Scope is appropriate

Present a summary table of all PRDs with their status.
```

Mark PRDs as "Approved" when ready to proceed.

---

## Phase 3: Setup

### Step 7: Bootstrap Project Structure

**Prompt:** [`prompts/webapp-fullstack-setup.md`](prompts/webapp-fullstack-setup.md)

```
Using the webapp-fullstack-setup prompt, create the project structure:

Project name: [your-app-name]
Tech stack: Next.js + Python FastAPI + Firebase

Create:
1. /frontend - Next.js app with TypeScript, Tailwind
2. /backend - Python FastAPI with Firebase Admin
3. /firebase - Security rules
4. Update CLAUDE.md with full project context
5. Environment variable templates

Reference PRD-001 and PRD-002 for feature requirements.
```

**What this creates:**
- Complete frontend scaffolding
- Complete backend scaffolding
- Firebase configuration files
- Updated CLAUDE.md
- Docker and deployment configs

### Step 8: Configure Firebase

**Prompt:** [`prompts/firebase-integration-best-practices.md`](prompts/firebase-integration-best-practices.md)

```
Using the firebase-integration-best-practices prompt:

1. Set up Firebase client SDK in frontend
2. Set up Firebase Admin SDK in backend
3. Configure Firestore security rules for users collection
4. Configure Storage rules for user uploads
5. Set up emulator configuration for local development

Reference the user model from PRD-001.
```

### Step 9: Set Up CI/CD

**Prompt:** [`prompts/github-actions-optimization.md`](prompts/github-actions-optimization.md)

```
Using the github-actions-optimization prompt, create GitHub workflows:

1. ci.yml - Lint, type-check, test on PRs
2. deploy-frontend.yml - Deploy to Firebase Hosting on main
3. deploy-backend.yml - Deploy to Cloud Run on main
4. preview.yml - Preview deployments for PRs

Include:
- Dependency caching
- Parallel jobs where possible
- Environment variable handling
- Build artifact caching
```

---

## Phase 4: Implementation

### Step 10: Implement Authentication

**Primary prompt:** [`prompts/security-best-practices.md`](prompts/security-best-practices.md)
**Supporting prompt:** [`prompts/clean-code-refactoring.md`](prompts/clean-code-refactoring.md)

```
Implement PRD-001 (User Authentication):

Using security-best-practices for:
- Firebase Auth integration
- Protected route middleware
- Token validation in backend
- Secure session handling

Using clean-code-refactoring for:
- Auth context and hooks
- Reusable auth components
- Clean error handling

Acceptance criteria from PRD-001:
[Copy acceptance criteria here]
```

**Implementation order:**
1. Backend auth middleware
2. Frontend Firebase client
3. Auth context provider
4. Login page
5. Signup page
6. Protected route wrapper
7. User profile API endpoints

### Step 11: Implement Core Features

**Primary prompt:** [`prompts/clean-code-refactoring.md`](prompts/clean-code-refactoring.md)
**Supporting prompt:** [`prompts/api-design-principles.md`](prompts/api-design-principles.md)

```
Implement PRD-002 (User Dashboard):

Following clean-code-refactoring for component design.
Following api-design-principles for any new endpoints.

Create:
1. Dashboard page layout
2. Stats cards components
3. Activity feed component
4. User profile card
5. Any required API endpoints

Acceptance criteria from PRD-002:
[Copy acceptance criteria here]
```

### Step 12: Build UI Components

**Prompt:** [`prompts/nextjs-best-practices.md`](prompts/nextjs-best-practices.md)

```
Using nextjs-best-practices, enhance the UI:

1. Set up Shadcn/UI components
2. Create consistent layout components
3. Add loading states and skeletons
4. Implement error boundaries
5. Add responsive design
6. Optimize images and fonts
```

---

## Phase 5: Quality

### Step 13: Write Tests

**Prompt:** [`prompts/test-driven-development.md`](prompts/test-driven-development.md)

```
Using test-driven-development, add comprehensive tests:

Frontend (Jest + React Testing Library):
- Auth components tests
- Dashboard components tests
- Hook tests
- Integration tests

Backend (pytest):
- Auth middleware tests
- API endpoint tests
- Service layer tests

Target: 80% coverage on critical paths.
```

### Step 14: Security Audit

**Prompt:** [`prompts/security-best-practices.md`](prompts/security-best-practices.md)

```
Using security-best-practices, perform a security audit:

Check for:
1. OWASP Top 10 vulnerabilities
2. Firebase security rules completeness
3. API authentication on all endpoints
4. Input validation
5. XSS prevention
6. CORS configuration
7. Secret management

Generate a security checklist with pass/fail status.
```

### Step 15: Performance Check

**Prompt:** [`prompts/performance-optimization.md`](prompts/performance-optimization.md)

```
Using performance-optimization, analyze and improve:

Frontend:
- Bundle size analysis
- Lighthouse score
- Core Web Vitals
- Image optimization

Backend:
- API response times
- Database query optimization
- Caching opportunities

Generate performance report with recommendations.
```

---

## Phase 6: Launch

### Step 16: Final Code Review

**Prompt:** [`prompts/code-review-best-practices.md`](prompts/code-review-best-practices.md)

```
Using code-review-best-practices, perform final review:

Review all code for:
1. PRD acceptance criteria met
2. Test coverage adequate
3. Security considerations addressed
4. Performance optimized
5. Documentation complete
6. Code style consistent

Generate final review report.
```

### Step 17: Deploy

```
Deploy the application:

1. Verify all environment variables are set in CI/CD
2. Run full test suite
3. Deploy backend to Cloud Run
4. Deploy frontend to Firebase Hosting
5. Deploy security rules
6. Verify production health checks
7. Run smoke tests on production
```

### Step 18: Post-Launch

```
Post-launch setup:

1. Enable Firebase Analytics
2. Set up error monitoring (Sentry)
3. Configure uptime monitoring
4. Create runbook for common issues
5. Update PRDs to "Done" status
6. Create retrospective notes
```

---

## Quick Reference

### Prompt Selection Guide

| Task | Primary Prompt | When to Use |
|------|----------------|-------------|
| New feature planning | `prd-driven-development` | Before any feature work |
| Project setup | `webapp-fullstack-setup` | Initial scaffolding |
| React components | `nextjs-best-practices` | Frontend development |
| API endpoints | `api-design-principles` | Backend development |
| Firebase setup | `firebase-integration-best-practices` | Database/auth setup |
| Writing tests | `test-driven-development` | After implementation |
| Security review | `security-best-practices` | Before launch |
| CI/CD setup | `github-actions-optimization` | Deployment automation |
| Code quality | `clean-code-refactoring` | During development |
| Code review | `code-review-best-practices` | Before merging PRs |
| Performance | `performance-optimization` | Optimization phase |

### Prompt Combinations

| Scenario | Prompts to Combine |
|----------|-------------------|
| New feature | `prd-driven-development` → `clean-code-refactoring` → `test-driven-development` |
| Bug fix | `prd-driven-development` → `test-driven-development` |
| Security feature | `security-best-practices` + `clean-code-refactoring` |
| Performance issue | `performance-optimization` + `clean-code-refactoring` |
| Pre-merge | `code-review-best-practices` + `security-best-practices` |

### Skill Usage

After setup, use these skills for common tasks:

```bash
/prd          # Create PRD for new feature
/component    # Generate React component
/api          # Generate API endpoint
/test         # Generate tests
/review       # Run code review checklist
```

---

## Example Timeline

### Week 1: Foundation & Planning
- Day 1: Steps 1-3 (Foundation)
- Day 2: Steps 4-6 (Planning)
- Day 3: Step 7 (Project setup)
- Day 4: Steps 8-9 (Firebase, CI/CD)
- Day 5: Begin Step 10 (Auth)

### Week 2: Implementation
- Days 1-2: Complete Step 10 (Auth)
- Days 3-4: Step 11 (Core features)
- Day 5: Step 12 (UI polish)

### Week 3: Quality & Launch
- Days 1-2: Step 13 (Tests)
- Day 3: Steps 14-15 (Security, Performance)
- Day 4: Step 16 (Final review)
- Day 5: Steps 17-18 (Deploy, Monitor)

---

## Checklist

### Foundation
- [ ] Empty project initialized
- [ ] PRD system set up
- [ ] Claude skills created
- [ ] CLAUDE.md configured

### Planning
- [ ] PRD-001: Authentication created
- [ ] PRD-002: Dashboard created
- [ ] Additional PRDs for features
- [ ] All PRDs approved

### Setup
- [ ] Frontend scaffolded
- [ ] Backend scaffolded
- [ ] Firebase configured
- [ ] CI/CD workflows created
- [ ] Environment variables documented

### Implementation
- [ ] Authentication working
- [ ] Dashboard implemented
- [ ] Core features complete
- [ ] UI polished

### Quality
- [ ] Tests written (80%+ coverage)
- [ ] Security audit passed
- [ ] Performance optimized
- [ ] Code review complete

### Launch
- [ ] Deployed to production
- [ ] Monitoring enabled
- [ ] Documentation updated
- [ ] PRDs marked as Done

---

## Related Files

- [`prompts/`](prompts/) - All available prompts
- [`README.md`](README.md) - Repository overview
- [`CONTRIBUTING.md`](CONTRIBUTING.md) - How to contribute new prompts
