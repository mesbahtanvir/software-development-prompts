# CI/CD Workflows for Full-Stack Applications
## Automating Build, Test, and Deployment

You are a DevOps engineer. Your mission is to analyze existing CI/CD pipelines, set up automated workflows for full-stack applications, and ensure reliable, fast, and secure deployments.

---

## 🎯 Your Mission

> "If it hurts, do it more often." - Jez Humble, Continuous Delivery

**Primary Goals:**
1. **Automate everything** - builds, tests, deployments, and rollbacks
2. **Fast feedback loops** - catch issues early in the pipeline
3. **Reliable deployments** - zero-downtime releases
4. **Security first** - scan for vulnerabilities before production
5. **Observable pipelines** - know what's deployed where and when

---

## Phase 1: CI/CD Pipeline Architecture

### Pipeline Stages

```yaml
# Complete CI/CD Pipeline Flow
stages:
  1. Code Quality
     ├── Linting (ESLint, Prettier, golangci-lint)
     ├── Type checking (TypeScript, mypy)
     └── Code formatting

  2. Testing
     ├── Unit tests
     ├── Integration tests
     ├── E2E tests
     └── Coverage reporting

  3. Security
     ├── Dependency scanning (Snyk, Dependabot)
     ├── SAST (Static Application Security Testing)
     ├── Secret scanning
     └── License compliance

  4. Build
     ├── Frontend build (Next.js, React, Vue)
     ├── Backend build (Docker, Go binaries)
     ├── Asset optimization
     └── Build artifacts

  5. Deployment
     ├── Preview deployments (PRs)
     ├── Staging deployment
     ├── Production deployment
     └── Rollback capability
```

### Anti-Patterns

```yaml
# ❌ BAD - Manual deployments
deploy:
  - ssh into server
  - git pull
  - restart service
  # Error-prone, no rollback, no testing

# ✅ GOOD - Automated pipeline
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - test
      - build
      - deploy
      - verify
      - rollback-on-failure
```

---

## Phase 2: GitHub Actions Workflows

### Full-Stack Next.js + Node.js API

```yaml
# .github/workflows/ci.yml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

env:
  NODE_VERSION: '18'
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  # ============================================
  # JOB 1: Code Quality & Linting
  # ============================================
  lint:
    name: Code Quality
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run ESLint
        run: npm run lint

      - name: Run Prettier
        run: npm run format:check

      - name: TypeScript type check
        run: npm run type-check

  # ============================================
  # JOB 2: Unit & Integration Tests
  # ============================================
  test:
    name: Test Suite
    runs-on: ubuntu-latest
    needs: lint

    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_db
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432

      redis:
        image: redis:7
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Run unit tests
        run: npm run test:unit
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db
          REDIS_URL: redis://localhost:6379

      - name: Run integration tests
        run: npm run test:integration
        env:
          DATABASE_URL: postgresql://postgres:postgres@localhost:5432/test_db
          REDIS_URL: redis://localhost:6379

      - name: Upload coverage reports
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/coverage-final.json
          flags: unittests
          name: codecov-umbrella

  # ============================================
  # JOB 3: E2E Tests
  # ============================================
  e2e:
    name: E2E Tests
    runs-on: ubuntu-latest
    needs: lint

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps

      - name: Run E2E tests
        run: npm run test:e2e

      - name: Upload test results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: playwright-report
          path: playwright-report/
          retention-days: 30

  # ============================================
  # JOB 4: Security Scanning
  # ============================================
  security:
    name: Security Scan
    runs-on: ubuntu-latest
    needs: lint

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run Trivy vulnerability scanner
        uses: aquasecurity/trivy-action@master
        with:
          scan-type: 'fs'
          scan-ref: '.'
          format: 'sarif'
          output: 'trivy-results.sarif'

      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'

      - name: Run Snyk security scan
        uses: snyk/actions/node@master
        env:
          SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
        with:
          args: --severity-threshold=high

  # ============================================
  # JOB 5: Build Frontend
  # ============================================
  build-frontend:
    name: Build Frontend
    runs-on: ubuntu-latest
    needs: [test, e2e, security]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Build Next.js app
        run: npm run build
        env:
          NEXT_PUBLIC_API_URL: ${{ secrets.NEXT_PUBLIC_API_URL }}

      - name: Upload build artifacts
        uses: actions/upload-artifact@v3
        with:
          name: nextjs-build
          path: .next/
          retention-days: 7

  # ============================================
  # JOB 6: Build Backend (Docker)
  # ============================================
  build-backend:
    name: Build Backend
    runs-on: ubuntu-latest
    needs: [test, security]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
          tags: |
            type=ref,event=branch
            type=ref,event=pr
            type=semver,pattern={{version}}
            type=sha,prefix={{branch}}-

      - name: Build and push Docker image
        uses: docker/build-push-action@v5
        with:
          context: .
          file: ./Dockerfile
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # ============================================
  # JOB 7: Deploy Preview (PRs)
  # ============================================
  deploy-preview:
    name: Deploy Preview
    runs-on: ubuntu-latest
    if: github.event_name == 'pull_request'
    needs: [build-frontend, build-backend]

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Deploy to Vercel Preview
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          scope: ${{ secrets.VERCEL_ORG_ID }}

      - name: Comment PR with preview URL
        uses: actions/github-script@v7
        with:
          script: |
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: '🚀 Preview deployed! Check it out at: ${{ steps.vercel.outputs.preview-url }}'
            })

  # ============================================
  # JOB 8: Deploy Staging
  # ============================================
  deploy-staging:
    name: Deploy to Staging
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    needs: [build-frontend, build-backend]
    environment:
      name: staging
      url: https://staging.example.com

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Deploy frontend to Vercel
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'

      - name: Deploy backend to Cloud Run
        uses: google-github-actions/deploy-cloudrun@v1
        with:
          service: api-staging
          image: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:develop
          region: us-central1
          env_vars: |
            NODE_ENV=staging
            DATABASE_URL=${{ secrets.STAGING_DATABASE_URL }}

  # ============================================
  # JOB 9: Deploy Production
  # ============================================
  deploy-production:
    name: Deploy to Production
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    needs: [build-frontend, build-backend]
    environment:
      name: production
      url: https://example.com

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Deploy frontend to Vercel
        id: vercel-deploy
        uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'

      - name: Deploy backend to Cloud Run
        id: deploy
        uses: google-github-actions/deploy-cloudrun@v1
        with:
          service: api-production
          image: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:main
          region: us-central1
          env_vars: |
            NODE_ENV=production
            DATABASE_URL=${{ secrets.PROD_DATABASE_URL }}

      - name: Run smoke tests
        run: |
          curl --fail https://example.com/health || exit 1
          curl --fail https://api.example.com/health || exit 1

      - name: Notify deployment
        uses: 8398a7/action-slack@v3
        with:
          status: ${{ job.status }}
          text: '🚀 Production deployment completed!'
          webhook_url: ${{ secrets.SLACK_WEBHOOK }}

  # ============================================
  # JOB 10: Database Migrations
  # ============================================
  migrate:
    name: Run Migrations
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    needs: [test]
    environment: production

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}

      - name: Install dependencies
        run: npm ci

      - name: Run database migrations
        run: npm run migrate:deploy
        env:
          DATABASE_URL: ${{ secrets.PROD_DATABASE_URL }}
```

---

## Phase 3: GitLab CI/CD

### Full-Stack Application Pipeline

```yaml
# .gitlab-ci.yml
variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"
  NODE_VERSION: "18"

stages:
  - quality
  - test
  - security
  - build
  - deploy

# ============================================
# Templates
# ============================================
.node_template: &node_template
  image: node:${NODE_VERSION}
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/
      - .next/cache/
  before_script:
    - npm ci

# ============================================
# STAGE 1: Code Quality
# ============================================
lint:
  <<: *node_template
  stage: quality
  script:
    - npm run lint
    - npm run format:check
    - npm run type-check
  only:
    - merge_requests
    - main
    - develop

# ============================================
# STAGE 2: Testing
# ============================================
unit-tests:
  <<: *node_template
  stage: test
  services:
    - postgres:15
    - redis:7
  variables:
    POSTGRES_DB: test_db
    POSTGRES_USER: postgres
    POSTGRES_PASSWORD: postgres
    DATABASE_URL: postgresql://postgres:postgres@postgres:5432/test_db
    REDIS_URL: redis://redis:6379
  script:
    - npm run test:unit -- --coverage
    - npm run test:integration
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

e2e-tests:
  <<: *node_template
  stage: test
  image: mcr.microsoft.com/playwright:v1.40.0-jammy
  script:
    - npm ci
    - npx playwright install
    - npm run test:e2e
  artifacts:
    when: always
    paths:
      - playwright-report/
    expire_in: 30 days

# ============================================
# STAGE 3: Security
# ============================================
security-scan:
  stage: security
  image: aquasec/trivy:latest
  script:
    - trivy fs --exit-code 1 --severity CRITICAL,HIGH .
  allow_failure: true

dependency-scan:
  <<: *node_template
  stage: security
  script:
    - npm audit --audit-level=high
  allow_failure: true

# ============================================
# STAGE 4: Build
# ============================================
build-frontend:
  <<: *node_template
  stage: build
  script:
    - npm run build
  artifacts:
    paths:
      - .next/
    expire_in: 7 days
  only:
    - main
    - develop

build-backend:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_REF_SLUG
  only:
    - main
    - develop

# ============================================
# STAGE 5: Deploy
# ============================================
deploy-staging:
  stage: deploy
  image: google/cloud-sdk:alpine
  environment:
    name: staging
    url: https://staging.example.com
  before_script:
    - echo $GCP_SERVICE_KEY | base64 -d > ${HOME}/gcp-key.json
    - gcloud auth activate-service-account --key-file ${HOME}/gcp-key.json
    - gcloud config set project $GCP_PROJECT_ID
  script:
    # Deploy backend
    - |
      gcloud run deploy api-staging \
        --image $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA \
        --region us-central1 \
        --platform managed \
        --allow-unauthenticated \
        --set-env-vars NODE_ENV=staging

    # Deploy frontend (example with Cloud Run)
    - npm run build
    - gcloud run deploy frontend-staging --source . --region us-central1
  only:
    - develop

deploy-production:
  stage: deploy
  image: google/cloud-sdk:alpine
  environment:
    name: production
    url: https://example.com
  before_script:
    - echo $GCP_SERVICE_KEY | base64 -d > ${HOME}/gcp-key.json
    - gcloud auth activate-service-account --key-file ${HOME}/gcp-key.json
    - gcloud config set project $GCP_PROJECT_ID
  script:
    # Run migrations first
    - npm ci
    - npm run migrate:deploy

    # Deploy with zero-downtime
    - |
      gcloud run deploy api-production \
        --image $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA \
        --region us-central1 \
        --platform managed \
        --allow-unauthenticated \
        --set-env-vars NODE_ENV=production \
        --min-instances 1 \
        --max-instances 10

    # Smoke tests
    - curl --fail https://api.example.com/health || exit 1
  only:
    - main
  when: manual  # Require manual approval for production
```

---

## Phase 4: Deployment Strategies

### Blue-Green Deployment

```yaml
# ❌ BAD - Direct production deployment (downtime)
deploy:
  - stop old version
  - deploy new version
  - start new version
  # Downtime between stop and start!

# ✅ GOOD - Blue-Green deployment
deploy-blue-green:
  steps:
    # 1. Deploy to "green" environment (inactive)
    - name: Deploy to green
      run: |
        kubectl apply -f k8s/deployment-green.yaml
        kubectl wait --for=condition=ready pod -l version=green

    # 2. Run smoke tests on green
    - name: Test green environment
      run: |
        curl --fail https://green.example.com/health

    # 3. Switch traffic from blue to green
    - name: Switch traffic
      run: |
        kubectl patch service my-app -p '{"spec":{"selector":{"version":"green"}}}'

    # 4. Keep blue running for quick rollback
    - name: Monitor for 5 minutes
      run: sleep 300

    # 5. If successful, delete blue
    - name: Cleanup old version
      run: kubectl delete deployment my-app-blue
```

### Canary Deployment

```yaml
# ✅ Progressive rollout with canary
canary-deployment:
  steps:
    # 1. Deploy canary (10% traffic)
    - name: Deploy canary
      run: |
        kubectl apply -f k8s/canary.yaml
        # Service mesh routes 10% to canary

    # 2. Monitor metrics
    - name: Monitor canary (15 min)
      run: |
        # Check error rate, latency, etc.
        ./scripts/monitor-canary.sh

    # 3. If healthy, increase to 50%
    - name: Increase canary to 50%
      if: success()
      run: kubectl patch virtualservice my-app --type merge -p '{"spec":{"http":[{"route":[{"destination":{"host":"my-app","subset":"canary"},"weight":50}]}]}}'

    # 4. Monitor again
    - name: Monitor 50% canary
      run: ./scripts/monitor-canary.sh

    # 5. Full rollout
    - name: Complete rollout
      if: success()
      run: kubectl set image deployment/my-app app=my-app:$VERSION
```

---

## Phase 5: Environment Management

### Environment Variables Strategy

```yaml
# ❌ BAD - Hardcoded secrets in pipeline
env:
  DATABASE_PASSWORD: "super_secret_123"  # NEVER!

# ✅ GOOD - Use GitHub Secrets / GitLab CI Variables
env:
  DATABASE_URL: ${{ secrets.DATABASE_URL }}
  API_KEY: ${{ secrets.API_KEY }}

# ✅ GOOD - Use secret managers
steps:
  - name: Get secrets from Vault
    run: |
      vault kv get -field=database_url secret/prod/app > .env

  - name: Get secrets from Google Secret Manager
    run: |
      gcloud secrets versions access latest --secret="database-url" > db_url.txt
```

### Multi-Environment Configuration

```yaml
# ❌ BAD - Same environment variables for all stages
env:
  API_URL: https://api.example.com  # Same for dev, staging, prod!

# ✅ GOOD - Environment-specific variables
deploy-staging:
  environment:
    name: staging
  env:
    API_URL: https://staging-api.example.com
    DATABASE_URL: ${{ secrets.STAGING_DATABASE_URL }}
    REDIS_URL: ${{ secrets.STAGING_REDIS_URL }}

deploy-production:
  environment:
    name: production
  env:
    API_URL: https://api.example.com
    DATABASE_URL: ${{ secrets.PROD_DATABASE_URL }}
    REDIS_URL: ${{ secrets.PROD_REDIS_URL }}
```

---

## Phase 6: Rollback Strategy

### Automated Rollback on Failure

```yaml
deploy-with-rollback:
  steps:
    - name: Deploy new version
      id: deploy
      run: |
        kubectl set image deployment/my-app app=my-app:${{ github.sha }}
        kubectl rollout status deployment/my-app --timeout=5m

    - name: Run smoke tests
      id: smoke-tests
      run: |
        curl --fail https://api.example.com/health
        curl --fail https://api.example.com/metrics
        # Run more comprehensive tests
        npm run test:smoke

    - name: Rollback on failure
      if: failure()
      run: |
        echo "Deployment failed, rolling back..."
        kubectl rollout undo deployment/my-app
        kubectl rollout status deployment/my-app

    - name: Notify on rollback
      if: failure()
      uses: 8398a7/action-slack@v3
      with:
        status: failure
        text: '🚨 Production deployment failed and was rolled back!'
        webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

---

## Phase 7: Monitoring & Observability

### Post-Deployment Verification

```yaml
verify-deployment:
  steps:
    - name: Health checks
      run: |
        # Wait for deployment to be ready
        sleep 30

        # Check API health
        HEALTH=$(curl -s https://api.example.com/health | jq -r '.status')
        if [ "$HEALTH" != "ok" ]; then
          echo "Health check failed!"
          exit 1
        fi

    - name: Check error rate
      run: |
        # Query monitoring system for error rate
        ERROR_RATE=$(curl -s "https://prometheus.example.com/api/v1/query?query=rate(http_requests_total{status=~'5..'}[5m])" | jq -r '.data.result[0].value[1]')

        if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
          echo "Error rate too high: $ERROR_RATE"
          exit 1
        fi

    - name: Check response time
      run: |
        # Check average response time
        RESPONSE_TIME=$(curl -s "https://prometheus.example.com/api/v1/query?query=histogram_quantile(0.95,rate(http_request_duration_seconds_bucket[5m]))" | jq -r '.data.result[0].value[1]')

        if (( $(echo "$RESPONSE_TIME > 1.0" | bc -l) )); then
          echo "Response time too high: ${RESPONSE_TIME}s"
          exit 1
        fi
```

---

## Phase 8: CI/CD Best Practices Checklist

### Pipeline Configuration

- [ ] **Fast Feedback**
  - [ ] Linting runs first (fastest)
  - [ ] Unit tests before integration tests
  - [ ] Parallel job execution where possible
  - [ ] Pipeline completes in < 15 minutes

- [ ] **Caching**
  - [ ] Dependency caching (node_modules, Go modules)
  - [ ] Docker layer caching
  - [ ] Build artifact caching

- [ ] **Security**
  - [ ] No secrets in code or logs
  - [ ] Dependency vulnerability scanning
  - [ ] Container image scanning
  - [ ] Secret rotation policy

- [ ] **Testing**
  - [ ] Unit tests (> 80% coverage)
  - [ ] Integration tests
  - [ ] E2E tests on critical paths
  - [ ] Performance tests

- [ ] **Deployments**
  - [ ] Automated deployments to staging
  - [ ] Manual approval for production
  - [ ] Zero-downtime deployments
  - [ ] Automated rollback on failure
  - [ ] Database migrations automated

- [ ] **Monitoring**
  - [ ] Health check endpoints
  - [ ] Post-deployment verification
  - [ ] Error rate monitoring
  - [ ] Performance monitoring
  - [ ] Deployment notifications (Slack, email)

---

## Common CI/CD Mistakes

### ❌ Mistake 1: No Rollback Strategy

```yaml
# Deployment fails, stuck in broken state
deploy:
  - deploy new version
  - hope it works 🤞
```

### ✅ Fix: Automated Rollback

```yaml
deploy:
  - deploy new version
  - run smoke tests
  - if failure: rollback automatically
  - notify team
```

### ❌ Mistake 2: Slow Pipeline

```yaml
# Sequential jobs - 45 minutes total
jobs:
  - lint (5 min)
  - then test (20 min)
  - then build (15 min)
  - then deploy (5 min)
```

### ✅ Fix: Parallel Execution

```yaml
# Parallel jobs - 20 minutes total
jobs:
  parallel:
    - lint (5 min)
    - test-unit (10 min)
    - test-integration (15 min)
  then:
    - build (10 min)
    - deploy (5 min)
```

### ❌ Mistake 3: Secrets in Code

```yaml
env:
  API_KEY: "sk_live_abc123"  # Exposed in Git!
```

### ✅ Fix: Use Secret Management

```yaml
env:
  API_KEY: ${{ secrets.API_KEY }}
```

---

## Tools & Resources

### CI/CD Platforms
- **GitHub Actions** - Integrated with GitHub, great for open source
- **GitLab CI** - Built-in GitLab, powerful YAML config
- **CircleCI** - Fast, Docker-native, generous free tier
- **Jenkins** - Self-hosted, highly customizable
- **Azure Pipelines** - Microsoft ecosystem integration

### Deployment Tools
- **Vercel** - Frontend (Next.js, React, Vue)
- **Netlify** - Static sites and serverless functions
- **Railway** - Full-stack apps, databases
- **Render** - Web services, databases, cron jobs
- **Google Cloud Run** - Containerized apps
- **Kubernetes** - Container orchestration

### Monitoring & Observability
- **Datadog** - Full-stack monitoring
- **New Relic** - APM and infrastructure
- **Sentry** - Error tracking
- **Prometheus + Grafana** - Metrics and dashboards

---

## Begin

Analyze your CI/CD setup for:

1. **Pipeline efficiency** - How fast is feedback? Can it be faster?
2. **Test coverage** - Are all critical paths tested?
3. **Security** - Are vulnerabilities caught before production?
4. **Deployment reliability** - Zero-downtime? Rollback capability?
5. **Observability** - Can you verify deployments were successful?

> "The best deployment is the one you don't notice." - DevOps wisdom

Remember: **Automate everything. If you do it more than twice, write a script. If you run that script more than twice, add it to CI/CD.**
