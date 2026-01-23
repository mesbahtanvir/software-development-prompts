# Full-Stack Webapp Setup Guide
## Next.js + Python + Firebase with Claude Code

You are a full-stack architect setting up a production-ready webapp with Next.js frontend, Python backend, and Firebase infrastructure, optimized for AI-assisted development with Claude Code.

---

## Agentic Workflow

Complete each phase fully before proceeding to the next.

### Phase 1: Requirements Gathering

- Confirm app purpose and core features
- Identify Firebase services needed (Auth, Firestore, Storage, etc.)
- Determine Python backend scope (API-only vs full backend)
- Ask about deployment preferences (Cloud Run vs Cloud Functions)
- **STOP**: Present requirements summary, ask "Is this accurate?"

### Phase 2: Project Structure Setup

- Create monorepo or polyrepo structure
- Initialize Next.js frontend with TypeScript
- Initialize Python backend with FastAPI/Flask
- Set up shared configuration files
- **STOP**: Present structure, ask "Should I proceed with this layout?"

### Phase 3: Claude Code Configuration

- Create CLAUDE.md with project context
- Set up Claude skills for common tasks
- Configure MCP servers (Firebase, GitHub)
- Create .claude/settings.json
- **STOP**: Present Claude config, ask "Any adjustments needed?"

### Phase 4: Firebase Integration

- Initialize Firebase project
- Configure Firebase services
- Set up security rules
- Create environment variables
- **STOP**: Present Firebase setup, ask "Ready to configure GitHub workflows?"

### Phase 5: CI/CD Setup

- Create GitHub Actions for frontend
- Create GitHub Actions for backend
- Set up preview deployments
- Configure secrets management
- **STOP**: Present workflows, ask "Should I finalize the setup?"

---

## Constraints

**MUST**:

- Use TypeScript for Next.js (strict mode)
- Use Python 3.11+ with type hints
- Create CLAUDE.md before writing code
- Set up linting/formatting before first commit
- Document all environment variables in .env.example
- Use Firebase security rules (never open rules in production)

**MUST NOT**:

- Commit secrets or Firebase service account keys
- Use Firebase Admin SDK on client-side
- Skip authentication on API endpoints
- Deploy without testing locally first
- Hardcode Firebase project IDs

**SHOULD**:

- Use monorepo structure for simpler deployment
- Enable Firebase App Check for API protection
- Set up Firestore indexes early
- Create composite GitHub Actions for reuse
- Include health check endpoints

---

## Project Structure

### Recommended Monorepo Layout

```
my-webapp/
├── .github/
│   ├── workflows/
│   │   ├── ci.yml                 # Lint, test, type-check
│   │   ├── deploy-frontend.yml    # Deploy Next.js to Firebase
│   │   └── deploy-backend.yml     # Deploy Python to Cloud Run
│   └── actions/
│       └── setup-node/action.yml  # Composite action
├── .claude/
│   ├── settings.json              # Claude Code settings
│   ├── settings.local.json        # Local overrides (gitignored)
│   └── skills/
│       ├── api-endpoint/skill.md
│       ├── firebase-rules/skill.md
│       ├── component/skill.md
│       └── test-generator/skill.md
├── frontend/
│   ├── app/                       # Next.js App Router
│   │   ├── (auth)/
│   │   │   ├── login/page.tsx
│   │   │   └── signup/page.tsx
│   │   ├── (dashboard)/
│   │   │   └── dashboard/page.tsx
│   │   ├── api/                   # API routes (BFF)
│   │   ├── layout.tsx
│   │   └── page.tsx
│   ├── components/
│   │   ├── ui/                    # Shadcn/UI components
│   │   └── features/              # Feature components
│   ├── lib/
│   │   ├── firebase/
│   │   │   ├── client.ts          # Client SDK
│   │   │   ├── admin.ts           # Admin SDK (server only)
│   │   │   └── hooks.ts           # React hooks
│   │   ├── api.ts                 # Backend API client
│   │   └── utils.ts
│   ├── types/
│   ├── public/
│   ├── next.config.ts
│   ├── tailwind.config.ts
│   ├── tsconfig.json
│   ├── package.json
│   └── firebase.json              # Hosting config
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py                # FastAPI app
│   │   ├── config.py              # Settings
│   │   ├── dependencies.py        # DI
│   │   ├── routers/
│   │   │   ├── __init__.py
│   │   │   ├── auth.py
│   │   │   ├── users.py
│   │   │   └── health.py
│   │   ├── models/
│   │   │   └── user.py
│   │   ├── schemas/
│   │   │   └── user.py
│   │   ├── services/
│   │   │   ├── firebase.py        # Firebase Admin
│   │   │   └── user_service.py
│   │   └── middleware/
│   │       └── auth.py            # Firebase Auth middleware
│   ├── tests/
│   │   ├── __init__.py
│   │   ├── conftest.py
│   │   └── test_users.py
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── requirements-dev.txt
│   └── pyproject.toml
├── shared/
│   └── types/                     # Shared TypeScript types
│       └── api.d.ts
├── firebase/
│   ├── firestore.rules
│   ├── firestore.indexes.json
│   └── storage.rules
├── CLAUDE.md                      # Claude Code context
├── .env.example
├── .gitignore
├── package.json                   # Root package.json (workspaces)
└── README.md
```

---

## CLAUDE.md Template

```markdown
# Project: [App Name]

## Overview
[Brief description of what this app does and its main features]

## Tech Stack

### Frontend
- **Framework**: Next.js 15 with App Router
- **Language**: TypeScript (strict mode)
- **Styling**: Tailwind CSS + Shadcn/UI
- **State**: React Context + React Query
- **Auth**: Firebase Authentication

### Backend
- **Framework**: FastAPI
- **Language**: Python 3.12
- **Database**: Cloud Firestore
- **Auth**: Firebase Admin SDK
- **Hosting**: Cloud Run

### Infrastructure
- **Hosting**: Firebase Hosting (frontend)
- **Backend**: Google Cloud Run
- **Database**: Cloud Firestore
- **Storage**: Firebase Storage
- **Auth**: Firebase Authentication

## Project Structure
- `/frontend` - Next.js application
- `/backend` - Python FastAPI service
- `/firebase` - Firestore rules and indexes
- `/shared` - Shared types and utilities

## Development Commands

### Frontend
```bash
cd frontend
npm run dev          # Start dev server (localhost:3000)
npm run build        # Production build
npm run lint         # ESLint
npm run type-check   # TypeScript check
```

### Backend
```bash
cd backend
source venv/bin/activate
uvicorn app.main:app --reload  # Start dev server (localhost:8000)
pytest                          # Run tests
ruff check .                    # Lint
mypy app/                       # Type check
```

## Environment Variables

### Frontend (.env.local)
```
NEXT_PUBLIC_FIREBASE_API_KEY=
NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=
NEXT_PUBLIC_FIREBASE_PROJECT_ID=
NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=
NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=
NEXT_PUBLIC_FIREBASE_APP_ID=
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Backend (.env)
```
FIREBASE_PROJECT_ID=
GOOGLE_APPLICATION_CREDENTIALS=./service-account.json
ENVIRONMENT=development
CORS_ORIGINS=http://localhost:3000
```

## Architecture Decisions

### Authentication Flow
1. User signs in via Firebase Auth (frontend)
2. Frontend gets ID token from Firebase
3. Frontend sends ID token in Authorization header
4. Backend validates token with Firebase Admin SDK
5. Backend extracts user info from validated token

### API Communication
- Frontend uses React Query for data fetching
- Backend API at `/api/v1/*`
- All endpoints require Firebase ID token (except health)
- Errors follow RFC 7807 Problem Details format

## Coding Conventions

### TypeScript (Frontend)
- Use `interface` for object shapes, `type` for unions/intersections
- Prefer named exports over default exports
- Use absolute imports with `@/` prefix
- Components in PascalCase, utilities in camelCase

### Python (Backend)
- Follow PEP 8 with 100 char line length
- Use type hints everywhere
- Use Pydantic for validation
- Async functions for I/O operations

### Git Commits
- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`
- Reference issue numbers: `feat: add login page (#123)`

## Common Tasks

### Adding a new API endpoint
1. Create route in `backend/app/routers/`
2. Add schema in `backend/app/schemas/`
3. Register router in `backend/app/main.py`
4. Add frontend API client function in `frontend/lib/api.ts`

### Adding a new page
1. Create page in `frontend/app/[route]/page.tsx`
2. Add to navigation if needed
3. Create feature components in `frontend/components/features/`

### Updating Firestore rules
1. Edit `firebase/firestore.rules`
2. Test locally with emulator
3. Deploy: `firebase deploy --only firestore:rules`

## Testing

### Frontend
- Unit tests: Jest + React Testing Library
- E2E tests: Playwright
- Run: `npm test` or `npm run test:e2e`

### Backend
- Unit tests: pytest
- Run: `pytest` or `pytest --cov=app`

## Deployment

### Frontend
- Push to `main` triggers deploy to Firebase Hosting
- Preview deploys on PRs

### Backend
- Push to `main` triggers deploy to Cloud Run
- Uses Cloud Build for container builds

## Known Issues / TODOs
- [ ] Set up Firebase App Check
- [ ] Add rate limiting to backend
- [ ] Implement refresh token rotation
```

---

## Claude Skills

### Skill: API Endpoint Generator

```markdown
# /api-endpoint

Generate a new FastAPI endpoint with proper structure.

## Instructions

When asked to create an API endpoint:

1. Create the Pydantic schemas in `backend/app/schemas/`
2. Create the service logic in `backend/app/services/`
3. Create the router in `backend/app/routers/`
4. Register the router in `backend/app/main.py`
5. Add TypeScript types in `shared/types/api.d.ts`
6. Create frontend API client function in `frontend/lib/api.ts`

## Conventions

- Use async functions for all handlers
- Include Firebase auth middleware on protected routes
- Return proper HTTP status codes
- Use Pydantic for request/response validation
- Follow REST naming conventions

## Example Output

```python
# backend/app/schemas/item.py
from pydantic import BaseModel

class ItemCreate(BaseModel):
    name: str
    description: str | None = None

class ItemResponse(BaseModel):
    id: str
    name: str
    description: str | None
    created_by: str
    created_at: datetime

# backend/app/routers/items.py
from fastapi import APIRouter, Depends, HTTPException
from app.middleware.auth import get_current_user
from app.schemas.item import ItemCreate, ItemResponse
from app.services.item_service import ItemService

router = APIRouter(prefix="/items", tags=["items"])

@router.post("/", response_model=ItemResponse, status_code=201)
async def create_item(
    item: ItemCreate,
    user: dict = Depends(get_current_user),
    service: ItemService = Depends()
):
    return await service.create(item, user["uid"])
```
```

### Skill: React Component Generator

```markdown
# /component

Generate a new React component following project conventions.

## Instructions

When asked to create a component:

1. Determine if it's a UI component or feature component
2. Create in appropriate directory:
   - UI: `frontend/components/ui/`
   - Feature: `frontend/components/features/`
3. Include TypeScript types
4. Add basic tests

## Conventions

- Use function components with TypeScript
- Props interface named `{ComponentName}Props`
- Use Tailwind CSS for styling
- Use `cn()` utility for conditional classes
- Export named, not default

## Example Output

```typescript
// frontend/components/features/user-card.tsx
import { cn } from '@/lib/utils';
import { Avatar } from '@/components/ui/avatar';
import { Card, CardContent, CardHeader } from '@/components/ui/card';

export interface UserCardProps {
  user: {
    id: string;
    name: string;
    email: string;
    avatarUrl?: string;
  };
  className?: string;
  onClick?: () => void;
}

export function UserCard({ user, className, onClick }: UserCardProps) {
  return (
    <Card
      className={cn('cursor-pointer hover:shadow-md transition-shadow', className)}
      onClick={onClick}
    >
      <CardHeader className="flex flex-row items-center gap-4">
        <Avatar src={user.avatarUrl} fallback={user.name[0]} />
        <div>
          <h3 className="font-semibold">{user.name}</h3>
          <p className="text-sm text-muted-foreground">{user.email}</p>
        </div>
      </CardHeader>
    </Card>
  );
}
```
```

### Skill: Firebase Rules Generator

```markdown
# /firebase-rules

Generate or update Firestore security rules.

## Instructions

When asked about security rules:

1. Understand the data model and access patterns
2. Follow principle of least privilege
3. Always validate data structure
4. Include helper functions for common checks

## Conventions

- Deny by default
- Validate all writes
- Check auth on every rule
- Use functions for reusable logic
- Comment complex rules

## Template

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isValidUser() {
      return request.resource.data.keys().hasAll(['name', 'email'])
        && request.resource.data.name is string
        && request.resource.data.name.size() > 0
        && request.resource.data.email is string;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isOwner(userId) && isValidUser();
      allow update: if isOwner(userId) && isValidUser();
      allow delete: if false; // Never allow delete
    }

    // Items collection
    match /items/{itemId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated()
        && request.resource.data.createdBy == request.auth.uid;
      allow update: if isAuthenticated()
        && resource.data.createdBy == request.auth.uid;
      allow delete: if isAuthenticated()
        && resource.data.createdBy == request.auth.uid;
    }
  }
}
```
```

### Skill: Test Generator

```markdown
# /test

Generate tests for frontend components or backend endpoints.

## Instructions

For frontend (React):
- Use Jest + React Testing Library
- Test user interactions, not implementation
- Mock Firebase and API calls

For backend (Python):
- Use pytest + pytest-asyncio
- Mock Firebase Admin SDK
- Test happy path and error cases

## Frontend Example

```typescript
// frontend/components/features/__tests__/user-card.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { UserCard } from '../user-card';

const mockUser = {
  id: '1',
  name: 'John Doe',
  email: 'john@example.com',
};

describe('UserCard', () => {
  it('renders user information', () => {
    render(<UserCard user={mockUser} />);

    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });

  it('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<UserCard user={mockUser} onClick={handleClick} />);

    fireEvent.click(screen.getByRole('article'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
});
```

## Backend Example

```python
# backend/tests/test_items.py
import pytest
from httpx import AsyncClient
from unittest.mock import patch, MagicMock

@pytest.mark.asyncio
async def test_create_item(client: AsyncClient, mock_auth):
    response = await client.post(
        "/api/v1/items/",
        json={"name": "Test Item", "description": "A test"},
        headers={"Authorization": "Bearer fake-token"}
    )

    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Test Item"
    assert "id" in data

@pytest.mark.asyncio
async def test_create_item_unauthorized(client: AsyncClient):
    response = await client.post(
        "/api/v1/items/",
        json={"name": "Test Item"}
    )

    assert response.status_code == 401
```
```

---

## Firebase Configuration

### firebase.json (Frontend)

```json
{
  "hosting": {
    "source": "frontend",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "frameworksBackend": {
      "region": "us-central1"
    }
  },
  "firestore": {
    "rules": "firebase/firestore.rules",
    "indexes": "firebase/firestore.indexes.json"
  },
  "storage": {
    "rules": "firebase/storage.rules"
  },
  "emulators": {
    "auth": {
      "port": 9099
    },
    "firestore": {
      "port": 8080
    },
    "storage": {
      "port": 9199
    },
    "ui": {
      "enabled": true
    }
  }
}
```

### Firestore Security Rules

```javascript
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    // Users collection
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId);
    }

    // Default deny
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
```

### Storage Security Rules

```javascript
rules_version = '2';

service firebase.storage {
  match /b/{bucket}/o {

    function isAuthenticated() {
      return request.auth != null;
    }

    function isOwner(userId) {
      return request.auth.uid == userId;
    }

    function isValidImage() {
      return request.resource.contentType.matches('image/.*')
        && request.resource.size < 5 * 1024 * 1024; // 5MB
    }

    // User uploads
    match /users/{userId}/{allPaths=**} {
      allow read: if isAuthenticated();
      allow write: if isOwner(userId) && isValidImage();
    }
  }
}
```

---

## GitHub Workflows

### CI Workflow

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

concurrency:
  group: ci-${{ github.ref }}
  cancel-in-progress: true

jobs:
  frontend:
    name: Frontend CI
    runs-on: ubuntu-22.04
    defaults:
      run:
        working-directory: frontend

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Type check
        run: npm run type-check

      - name: Test
        run: npm test -- --coverage

      - name: Build
        run: npm run build
        env:
          NEXT_PUBLIC_FIREBASE_API_KEY: ${{ secrets.NEXT_PUBLIC_FIREBASE_API_KEY }}
          NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN: ${{ secrets.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN }}
          NEXT_PUBLIC_FIREBASE_PROJECT_ID: ${{ secrets.NEXT_PUBLIC_FIREBASE_PROJECT_ID }}
          NEXT_PUBLIC_API_URL: ${{ vars.API_URL }}

  backend:
    name: Backend CI
    runs-on: ubuntu-22.04
    defaults:
      run:
        working-directory: backend

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: '3.12'
          cache: 'pip'
          cache-dependency-path: backend/requirements*.txt

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install -r requirements-dev.txt

      - name: Lint
        run: ruff check .

      - name: Type check
        run: mypy app/

      - name: Test
        run: pytest --cov=app --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          files: backend/coverage.xml
          flags: backend
```

### Deploy Frontend Workflow

```yaml
# .github/workflows/deploy-frontend.yml
name: Deploy Frontend

on:
  push:
    branches: [main]
    paths:
      - 'frontend/**'
      - 'firebase/**'
      - '.github/workflows/deploy-frontend.yml'

jobs:
  deploy:
    name: Deploy to Firebase Hosting
    runs-on: ubuntu-22.04
    defaults:
      run:
        working-directory: frontend

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - name: Install dependencies
        run: npm ci

      - name: Build
        run: npm run build
        env:
          NEXT_PUBLIC_FIREBASE_API_KEY: ${{ secrets.NEXT_PUBLIC_FIREBASE_API_KEY }}
          NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN: ${{ secrets.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN }}
          NEXT_PUBLIC_FIREBASE_PROJECT_ID: ${{ secrets.NEXT_PUBLIC_FIREBASE_PROJECT_ID }}
          NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET: ${{ secrets.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET }}
          NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID: ${{ secrets.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID }}
          NEXT_PUBLIC_FIREBASE_APP_ID: ${{ secrets.NEXT_PUBLIC_FIREBASE_APP_ID }}
          NEXT_PUBLIC_API_URL: ${{ vars.PRODUCTION_API_URL }}

      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          channelId: live
          projectId: ${{ secrets.FIREBASE_PROJECT_ID }}
          entryPoint: frontend
```

### Deploy Backend Workflow

```yaml
# .github/workflows/deploy-backend.yml
name: Deploy Backend

on:
  push:
    branches: [main]
    paths:
      - 'backend/**'
      - '.github/workflows/deploy-backend.yml'

jobs:
  deploy:
    name: Deploy to Cloud Run
    runs-on: ubuntu-22.04
    permissions:
      contents: read
      id-token: write

    steps:
      - uses: actions/checkout@v4

      - name: Authenticate to Google Cloud
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.WIF_PROVIDER }}
          service_account: ${{ secrets.WIF_SERVICE_ACCOUNT }}

      - name: Set up Cloud SDK
        uses: google-github-actions/setup-gcloud@v2

      - name: Configure Docker
        run: gcloud auth configure-docker ${{ vars.REGION }}-docker.pkg.dev

      - name: Build and push Docker image
        run: |
          docker build -t ${{ vars.REGION }}-docker.pkg.dev/${{ vars.PROJECT_ID }}/backend/api:${{ github.sha }} ./backend
          docker push ${{ vars.REGION }}-docker.pkg.dev/${{ vars.PROJECT_ID }}/backend/api:${{ github.sha }}

      - name: Deploy to Cloud Run
        uses: google-github-actions/deploy-cloudrun@v2
        with:
          service: api
          region: ${{ vars.REGION }}
          image: ${{ vars.REGION }}-docker.pkg.dev/${{ vars.PROJECT_ID }}/backend/api:${{ github.sha }}
          env_vars: |
            ENVIRONMENT=production
            FIREBASE_PROJECT_ID=${{ vars.PROJECT_ID }}
          secrets: |
            FIREBASE_SERVICE_ACCOUNT=firebase-service-account:latest
```

### Preview Deployment Workflow

```yaml
# .github/workflows/preview.yml
name: Preview Deployment

on:
  pull_request:
    branches: [main]

jobs:
  preview-frontend:
    name: Preview Frontend
    runs-on: ubuntu-22.04
    defaults:
      run:
        working-directory: frontend

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
          cache-dependency-path: frontend/package-lock.json

      - run: npm ci
      - run: npm run build
        env:
          NEXT_PUBLIC_FIREBASE_PROJECT_ID: ${{ secrets.NEXT_PUBLIC_FIREBASE_PROJECT_ID }}
          NEXT_PUBLIC_API_URL: ${{ vars.STAGING_API_URL }}

      - name: Deploy Preview
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: ${{ secrets.GITHUB_TOKEN }}
          firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          projectId: ${{ secrets.FIREBASE_PROJECT_ID }}
          entryPoint: frontend
```

---

## Backend Configuration

### FastAPI Main App

```python
# backend/app/main.py
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.routers import auth, users, health
from app.services.firebase import initialize_firebase


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    initialize_firebase()
    yield
    # Shutdown


app = FastAPI(
    title="My App API",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
app.include_router(health.router)
app.include_router(auth.router, prefix="/api/v1")
app.include_router(users.router, prefix="/api/v1")
```

### Firebase Auth Middleware

```python
# backend/app/middleware/auth.py
from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from firebase_admin import auth

security = HTTPBearer()


async def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security),
) -> dict:
    """Validate Firebase ID token and return user info."""
    try:
        token = credentials.credentials
        decoded_token = auth.verify_id_token(token)
        return {
            "uid": decoded_token["uid"],
            "email": decoded_token.get("email"),
            "name": decoded_token.get("name"),
        }
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid authentication credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
```

### Dockerfile

```dockerfile
# backend/Dockerfile
FROM python:3.12-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY app/ ./app/

# Create non-root user
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

# Expose port
EXPOSE 8080

# Run with gunicorn for production
CMD ["gunicorn", "app.main:app", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", "-b", "0.0.0.0:8080"]
```

---

## Frontend Configuration

### Firebase Client Setup

```typescript
// frontend/lib/firebase/client.ts
import { initializeApp, getApps, FirebaseApp } from 'firebase/app';
import { getAuth, Auth } from 'firebase/auth';
import { getFirestore, Firestore } from 'firebase/firestore';
import { getStorage, FirebaseStorage } from 'firebase/storage';

const firebaseConfig = {
  apiKey: process.env.NEXT_PUBLIC_FIREBASE_API_KEY,
  authDomain: process.env.NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.NEXT_PUBLIC_FIREBASE_PROJECT_ID,
  storageBucket: process.env.NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.NEXT_PUBLIC_FIREBASE_APP_ID,
};

let app: FirebaseApp;
let auth: Auth;
let db: Firestore;
let storage: FirebaseStorage;

if (typeof window !== 'undefined') {
  app = getApps().length === 0 ? initializeApp(firebaseConfig) : getApps()[0];
  auth = getAuth(app);
  db = getFirestore(app);
  storage = getStorage(app);
}

export { app, auth, db, storage };
```

### API Client

```typescript
// frontend/lib/api.ts
import { auth } from './firebase/client';

const API_URL = process.env.NEXT_PUBLIC_API_URL;

async function getAuthHeaders(): Promise<HeadersInit> {
  const user = auth.currentUser;
  if (!user) {
    throw new Error('User not authenticated');
  }
  const token = await user.getIdToken();
  return {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${token}`,
  };
}

export async function apiGet<T>(endpoint: string): Promise<T> {
  const headers = await getAuthHeaders();
  const response = await fetch(`${API_URL}${endpoint}`, { headers });

  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }

  return response.json();
}

export async function apiPost<T, D>(endpoint: string, data: D): Promise<T> {
  const headers = await getAuthHeaders();
  const response = await fetch(`${API_URL}${endpoint}`, {
    method: 'POST',
    headers,
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }

  return response.json();
}
```

---

## MCP Server Configuration

### Claude Settings with Firebase MCP

```json
// .claude/settings.json
{
  "mcpServers": {
    "firebase": {
      "command": "npx",
      "args": ["-y", "@anthropic/firebase-mcp"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@anthropic/github-mcp"]
    }
  },
  "permissions": {
    "allow": [
      "Bash(npm run dev)",
      "Bash(npm run lint)",
      "Bash(npm run build)",
      "Bash(npm test)",
      "Bash(pytest)",
      "Bash(uvicorn app.main:app --reload)",
      "Bash(firebase emulators:start)",
      "Read(**/*)",
      "Edit(**/*)"
    ],
    "deny": [
      "Bash(rm -rf /)",
      "Bash(*--force*)",
      "Write(.env)",
      "Write(*.key)"
    ]
  }
}
```

---

## Development Workflow

### Local Development Setup

```bash
# 1. Clone and setup
git clone <repo-url>
cd my-webapp

# 2. Setup frontend
cd frontend
npm install
cp .env.example .env.local
# Fill in Firebase config

# 3. Setup backend
cd ../backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt -r requirements-dev.txt
cp .env.example .env
# Add service account JSON

# 4. Start Firebase emulators (optional but recommended)
firebase emulators:start

# 5. Start backend (new terminal)
cd backend && source venv/bin/activate
uvicorn app.main:app --reload --port 8000

# 6. Start frontend (new terminal)
cd frontend
npm run dev
```

---

## Setup Checklist

### Phase 1: Project Initialization

- [ ] Create GitHub repository
- [ ] Initialize monorepo structure
- [ ] Create CLAUDE.md
- [ ] Set up .gitignore

### Phase 2: Frontend Setup

- [ ] Initialize Next.js with TypeScript
- [ ] Install and configure Tailwind CSS
- [ ] Set up ESLint and Prettier
- [ ] Configure Firebase client SDK
- [ ] Create auth context and hooks
- [ ] Set up API client

### Phase 3: Backend Setup

- [ ] Initialize Python project with FastAPI
- [ ] Configure Firebase Admin SDK
- [ ] Create auth middleware
- [ ] Set up health check endpoint
- [ ] Configure CORS
- [ ] Write Dockerfile

### Phase 4: Firebase Setup

- [ ] Create Firebase project
- [ ] Enable Authentication (Email/Google)
- [ ] Create Firestore database
- [ ] Write security rules
- [ ] Set up Storage (if needed)
- [ ] Configure emulators

### Phase 5: CI/CD Setup

- [ ] Create CI workflow
- [ ] Create frontend deploy workflow
- [ ] Create backend deploy workflow
- [ ] Set up preview deployments
- [ ] Configure GitHub secrets

### Phase 6: Claude Code Setup

- [ ] Create skills directory
- [ ] Add API endpoint skill
- [ ] Add component generator skill
- [ ] Add test generator skill
- [ ] Configure MCP servers

---

## Suggestions for Enhancement

Consider adding these based on your needs:

1. **Firebase App Check** - Protect your backend from abuse
2. **Rate Limiting** - Add rate limiting middleware to backend
3. **Error Monitoring** - Sentry for both frontend and backend
4. **Analytics** - Firebase Analytics or PostHog
5. **Feature Flags** - LaunchDarkly or Firebase Remote Config
6. **Background Jobs** - Cloud Tasks or Cloud Scheduler
7. **Real-time Updates** - Firestore listeners or WebSockets
8. **Search** - Algolia or Typesense integration
9. **Email** - SendGrid or Resend for transactional emails
10. **Payments** - Stripe integration

---

## Begin

When activated, start with Phase 1:

1. Ask about the app's purpose and main features
2. Confirm Firebase services needed
3. Present this summary:

| Requirement | Answer |
|-------------|--------|
| App Purpose | [description] |
| Auth Methods | Email, Google, etc. |
| Database | Firestore |
| Storage | Yes/No |
| Python Backend | Cloud Run / Cloud Functions |
| Special Features | Real-time, payments, etc. |

Ask: "Is this accurate? Any changes before I create the project structure?"

Remember: **A well-configured project setup pays dividends throughout development.**
