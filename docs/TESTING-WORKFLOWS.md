<!--
SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors

SPDX-License-Identifier: MIT
-->

# Testing GitHub Actions Workflows Locally

This guide explains how to test GitHub Actions workflows locally on your Mac before pushing to GitHub.

## Why Test Locally?

- **Faster feedback**: No need to push and wait for CI
- **Save CI minutes**: Especially important for private repositories
- **Debug workflows**: Easier to troubleshoot issues locally
- **Iterate quickly**: Test changes without cluttering git history

## Prerequisites

### Install act

**act** is a tool that runs GitHub Actions locally using Docker containers.

**Installation via Homebrew (recommended for Mac):**
```bash
brew install act
```

**Or use the Makefile:**
```bash
make act-install
```

**Manual installation:**
```bash
# Download from https://github.com/nektos/act/releases
curl -s https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

### Docker Desktop

act requires Docker to run workflows in containers:
- Install from: https://www.docker.com/products/docker-desktop/
- Make sure Docker Desktop is running before using act

## Quick Start

### List Available Workflows

```bash
# Using Makefile
make act-list

# Or directly with act
act -l
```

### Run Specific Workflows

```bash
# Run test workflow
make act-test

# Run build workflow
make act-build

# Run linting workflow
make act-lint

# Run REUSE compliance check
make act-reuse

# Run vulnerability check
make act-vuln
```

### Run All Testable Workflows

```bash
make act-all
```

## Workflow-by-Workflow Guide

### 1. Build Workflow (`.github/workflows/build.yaml`)

Tests that your code compiles correctly.

```bash
# Using Makefile
make act-build

# Or with act directly
act -W .github/workflows/build.yaml

# Run on push event
act push -W .github/workflows/build.yaml

# Run on pull_request event
act pull_request -W .github/workflows/build.yaml
```

### 2. Test Workflow (`.github/workflows/test.yaml`)

Runs your test suite across multiple Go versions and operating systems.

```bash
# Using Makefile
make act-test

# Test with specific matrix
act -W .github/workflows/test.yaml -j test --matrix os:ubuntu-latest --matrix go-version:stable
```

**Note**: The test workflow has a matrix strategy (multiple OS and Go versions). act will run all combinations by default, which may take time.

### 3. Linting Workflow (`.github/workflows/golangci-lint.yaml`)

Runs golangci-lint to check code quality.

```bash
# Using Makefile
make act-lint

# Or with act
act -W .github/workflows/golangci-lint.yaml
```

### 4. REUSE Compliance (`.github/workflows/reuse.yaml`)

Checks REUSE licensing compliance.

```bash
# Using Makefile
make act-reuse

# Or with act
act -W .github/workflows/reuse.yaml
```

### 5. Vulnerability Check (`.github/workflows/govulncheck.yaml`)

Scans for known vulnerabilities in dependencies.

```bash
# Using Makefile
make act-vuln

# Or with act
act -W .github/workflows/govulncheck.yaml
```

### 6. Release Workflow (`.github/workflows/release.yaml`)

**Cannot be tested locally** - This uses OpenCHAMI's shared workflow which requires specific GitHub secrets and registry access.

### 7. CodeQL (`.github/workflows/codeql.yaml`)

**Limited local testing** - CodeQL requires GitHub's infrastructure. You can test the basic setup, but full analysis requires GitHub.

### 8. OpenSSF Scorecard (`.github/workflows/scorecard.yaml`)

**Cannot be tested locally** - Requires GitHub's security infrastructure.

### 9. Dependency Review (`.github/workflows/dependency-review.yaml`)

**Cannot be tested locally** - Only runs on pull requests and requires GitHub's dependency graph.

## Advanced Usage

### Run with Specific Event

```bash
# Simulate a push event
act push -W .github/workflows/build.yaml

# Simulate a pull request
act pull_request -W .github/workflows/test.yaml

# Simulate a tag push (for releases)
act push --ref refs/tags/v1.0.0
```

### Run Specific Job

```bash
# List jobs in a workflow
act -l -W .github/workflows/test.yaml

# Run specific job
act -j test -W .github/workflows/test.yaml
```

### Use Different Container Images

By default, act uses medium-sized images. You can customize:

```bash
# Use larger images (closer to GitHub's environment)
act -P ubuntu-latest=catthehacker/ubuntu:full-latest

# Use smaller images (faster, but may miss some tools)
act -P ubuntu-latest=node:16-buster-slim
```

### Secrets and Environment Variables

```bash
# Pass secrets
act -s GITHUB_TOKEN=your_token

# Use secrets file
echo "GITHUB_TOKEN=your_token" > .secrets
act --secret-file .secrets

# Set environment variables
act -e MY_VAR=value
```

### Dry Run

```bash
# Show what would run without executing
act -n -W .github/workflows/build.yaml

# Show verbose output
act -v -W .github/workflows/build.yaml
```

## Limitations

### What Works Locally:

✅ Basic build and test workflows
✅ Linting and code quality checks
✅ REUSE compliance checks
✅ Vulnerability scanning
✅ Most matrix strategies
✅ Checkout, setup actions

### What Doesn't Work (or is Limited):

❌ GitHub-specific services (CodeQL, Scorecard)
❌ Workflows using GitHub secrets from settings
❌ Workflows calling reusable workflows from other repos
❌ GitHub Container Registry push operations
❌ Dependency Review (requires GitHub dependency graph)
❌ Some GitHub-native actions may behave differently

## Troubleshooting

### Docker Not Running

```
Error: Cannot connect to the Docker daemon
```

**Solution**: Start Docker Desktop

### Large Images Taking Time

**Solution**: Use smaller images or pull once:
```bash
docker pull catthehacker/ubuntu:act-latest
```

### Workflow Fails Locally But Passes on GitHub

**Common causes**:
- Different container images
- Missing environment variables
- GitHub-specific features not available locally
- File permission differences

**Solution**: Run with verbose flag to debug:
```bash
act -v -W .github/workflows/your-workflow.yaml
```

### Out of Disk Space

act downloads Docker images which can be large.

**Solution**: Clean up Docker:
```bash
docker system prune -a
```

## Best Practices

1. **Test before pushing**: Run `make act-all` before committing
2. **Focus on unit tests**: Local workflow testing is best for build/test/lint
3. **Use selective testing**: Test specific workflows that you changed
4. **Keep workflows simple**: Complex workflows are harder to test locally
5. **Document limitations**: Note which workflows can't be tested locally
6. **Use .actrc**: Create `.actrc` file for default act configurations

### Example .actrc Configuration

```bash
# Create .actrc in your repository root
cat > .actrc << 'EOF'
# Use medium-sized images (good balance)
-P ubuntu-latest=catthehacker/ubuntu:act-latest

# Reuse containers for faster runs
--reuse

# Bind workspace to preserve state
--bind
EOF
```

## Integration with Development Workflow

### Recommended Workflow

```bash
# 1. Make changes
git checkout -b feature/my-feature

# 2. Run local checks
make pre-commit-run  # Quick checks

# 3. Test workflows locally
make act-build      # Test build
make act-test       # Run tests
make act-lint       # Check linting

# 4. Commit if everything passes
git commit -m "feat: add new feature"

# 5. Push to GitHub
git push origin feature/my-feature
```

### CI/CD Pipeline

```
Local Development → Pre-commit Hooks → Act Testing → Push → GitHub Actions → Deploy
     (seconds)         (seconds)        (minutes)    (minutes)      (deploy)
```

## Additional Resources

- **act Documentation**: https://github.com/nektos/act
- **GitHub Actions Documentation**: https://docs.github.com/en/actions
- **act Runner Images**: https://github.com/catthehacker/docker_images
- **OpenCHAMI GitHub Actions**: https://github.com/OpenCHAMI/github-actions

## Summary of Make Targets

```bash
make act-install    # Install act via Homebrew
make act-list       # List all workflows
make act-build      # Test build workflow
make act-test       # Test test workflow
make act-lint       # Test linting workflow
make act-reuse      # Test REUSE compliance
make act-vuln       # Test vulnerability check
make act-all        # Run all testable workflows
```

---

**Pro Tip**: Add `make act-all` to your development routine to catch issues before they reach CI! 🚀
