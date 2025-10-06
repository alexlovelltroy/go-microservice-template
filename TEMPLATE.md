<!--
SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors

SPDX-License-Identifier: MIT
-->

# OpenCHAMI Go Microservice Template - Documentation

[![Build](https://github.com/OpenCHAMI/go-microservice-template/actions/workflows/build.yaml/badge.svg)](https://github.com/OpenCHAMI/go-microservice-template/actions/workflows/build.yaml)
[![Test](https://github.com/OpenCHAMI/go-microservice-template/actions/workflows/test.yaml/badge.svg)](https://github.com/OpenCHAMI/go-microservice-template/actions/workflows/test.yaml)
[![Go Report Card](https://goreportcard.com/badge/github.com/OpenCHAMI/go-microservice-template)](https://goreportcard.com/report/github.com/OpenCHAMI/go-microservice-template)
[![License](https://img.shields.io/github/license/OpenCHAMI/go-microservice-template)](https://github.com/OpenCHAMI/go-microservice-template/blob/main/LICENSE)
[![REUSE status](https://api.reuse.software/badge/github.com/OpenCHAMI/go-microservice-template)](https://api.reuse.software/info/github.com/OpenCHAMI/go-microservice-template)
[![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/OpenCHAMI/go-microservice-template/badge)](https://securityscorecards.dev/viewer/?uri=github.com/OpenCHAMI/go-microservice-template)

> **This is the template documentation file.** It contains detailed information about all the features,
> workflows, and tools included in this template. This file is preserved when you use the template setup script,
> while the main README.md is replaced with a clean starter README for your new project.

**Template repository for creating new Go microservices in the OpenCHAMI project.**

## Features

- 🚀 Ready-to-use Go project structure
- 🔨 Pre-configured GoReleaser for multi-platform builds
- 🐳 Docker multi-architecture support (amd64, arm64)
- 🔍 Comprehensive code quality workflows
- 🔒 Security scanning with OpenSSF Scorecard and CodeQL
- 📦 Automated dependency management with Dependabot
- ✅ golangci-lint configuration with best practices
- 🧪 Test and build workflows
- ⚖️ REUSE-compliant licensing with automated validation
- 🪝 Pre-commit hooks for code quality and compliance checks

## Getting Started

### Quick Start

```bash
# 1. Use this template on GitHub and clone your new repository
git clone https://github.com/OpenCHAMI/your-service-name.git
cd your-service-name

# 2. Run the setup script to customize the template
./scripts/setup-template.sh

# 3. Set up development environment (installs pre-commit, REUSE, etc.)
make setup-dev

# 4. Start developing!
make build
make test
```

### Using This Template

#### Automated Setup (Recommended)

1. Click "Use this template" button on GitHub
2. Clone your new repository
3. Run the setup script: `./scripts/setup-template.sh`
   - This will prompt you for:
     - Repository owner/organization
     - Repository name
     - Project description
     - Copyright holder
   - It automatically updates all files with your information
4. Run `make setup-dev` to install development tools
5. Start coding!

#### Manual Setup

If you prefer to manually configure the template:

1. Click "Use this template" button on GitHub
2. Clone your new repository
3. Run `make setup-dev` to install development tools
4. Update the following files with your project details:
   - `README.md` - Update all badge URLs and project description
   - `go.mod` - Change module path: `github.com/OpenCHAMI/your-service-name`
   - `.goreleaser.yaml` - Update GitHub owner and repository name
   - `.github/CODEOWNERS` - Update team/owner references
   - `LICENSES/MIT.txt` - Update copyright year and holder
   - All workflow files - Update repository references in badges
5. Run `make reuse-annotate` to add copyright headers to your files
6. Run `go mod tidy` to update dependencies

### Prerequisites

- Go 1.21 or later
- Docker (for container builds)
- golangci-lint (for local linting)
- Python 3 with pipx (for pre-commit and REUSE tools) - optional but recommended

**Quick setup:**
```bash
# Install pipx (if not already installed)
python3 -m pip install --user pipx
python3 -m pipx ensurepath

# Install all development tools and set up hooks
make setup-dev
```

### Project Structure

```
.
├── .github/
│   ├── workflows/
│   │   ├── build.yaml              # Build verification
│   │   ├── test.yaml               # Run tests across platforms
│   │   ├── golangci-lint.yaml      # Code quality checks
│   │   ├── release.yaml            # Release builds with GoReleaser
│   │   ├── scorecard.yaml          # OpenSSF security scorecard
│   │   ├── codeql.yaml             # CodeQL security analysis
│   │   ├── dependency-review.yaml  # PR dependency checks
│   │   ├── govulncheck.yaml        # Vulnerability scanning
│   │   └── reuse.yaml              # REUSE compliance check
│   ├── dependabot.yml              # Automated dependency updates
│   └── CODEOWNERS                  # Code ownership definitions
├── LICENSES/
│   └── MIT.txt                     # MIT License text
├── docs/
│   └── TESTING-WORKFLOWS.md        # Guide for testing workflows locally
├── scripts/
│   └── setup-template.sh           # Template setup automation script
├── .gitignore                      # Git ignore patterns
├── .golangci.yaml                  # golangci-lint configuration
├── .goreleaser.yaml                # GoReleaser configuration
├── .pre-commit-config.yaml         # Pre-commit hooks configuration
├── CHANGELOG.md                    # Project changelog
├── CONTRIBUTING.md                 # Contribution guidelines
├── Dockerfile                      # Container image definition
├── LICENSE                         # License file with REUSE headers
├── Makefile                        # Build automation
├── README.md                       # Project README (replaced by setup script)
├── README.template                 # Clean README template (used by setup script)
├── REUSE.toml                      # REUSE configuration for bulk licensing
├── TEMPLATE.md                     # This file - Template documentation
├── go.mod                          # Go module definition
├── go.sum                          # Go module checksums
└── main.go                         # Application entry point
```

## Development

### Setting Up Development Environment

```bash
# One-time setup: Install development tools and pre-commit hooks
make setup-dev

# After setup, annotate all files with REUSE headers
make reuse-annotate
```

### Local Development

```bash
# Install dependencies
go mod download

# Run tests
go test -v ./...

# Run linter
golangci-lint run

# Build locally
go build -o bin/app .

# Run the application
./bin/app

# Run pre-commit hooks manually
make pre-commit-run
```

### Pre-commit Hooks

This template includes pre-commit hooks that run automatically before each commit:

- **Trailing whitespace removal**
- **End-of-file fixer**
- **YAML validation**
- **REUSE compliance check**
- **Go formatting** (`go fmt`)
- **Go module tidying** (`go mod tidy`)
- **Go tests** (`go test`)
- **Go vet** (`go vet`)
- **golangci-lint** (comprehensive linting)

**Pre-commit commands:**
```bash
# Install pre-commit (one-time)
make pre-commit-install

# Set up hooks (one-time)
make pre-commit-setup

# Run hooks manually on all files
make pre-commit-run

# Update hooks to latest versions
make pre-commit-update

# Skip hooks for a commit (not recommended)
git commit --no-verify -m "message"
```

### Testing GitHub Actions Workflows Locally

You can test GitHub Actions workflows locally using **act** before pushing to GitHub:

```bash
# Install act (one-time)
make act-install

# List available workflows
make act-list

# Test specific workflows
make act-build      # Test build workflow
make act-test       # Run tests locally
make act-lint       # Test linting
make act-reuse      # Test REUSE compliance

# Run all testable workflows
make act-all
```

**See [docs/TESTING-WORKFLOWS.md](docs/TESTING-WORKFLOWS.md) for detailed guide.**

### Building with GoReleaser

```bash
# Test the release process (snapshot)
goreleaser release --snapshot --clean

# Create a release (requires a git tag)
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

## CI/CD Workflows

### Automated Workflows

- **Build**: Runs on every push and PR to verify the code compiles
- **Test**: Runs tests across multiple OS and Go versions
- **golangci-lint**: Performs comprehensive code quality checks
- **Release**: Triggered on version tags, builds and publishes releases
- **OpenSSF Scorecard**: Weekly security posture assessment
- **CodeQL**: Security vulnerability scanning
- **Dependency Review**: Checks dependencies in PRs for known vulnerabilities
- **govulncheck**: Daily vulnerability scanning of Go dependencies
- **REUSE**: Validates REUSE compliance for all files

### Release Process

1. Ensure all tests pass
2. Update CHANGELOG.md with release notes
3. Create and push a semantic version tag:
   ```bash
   git tag -a v1.0.0 -m "Release v1.0.0"
   git push origin v1.0.0
   ```
4. GitHub Actions will automatically:
   - Build binaries for multiple platforms
   - Create Docker images for amd64 and arm64
   - Generate checksums and SBOMs
   - Create a GitHub release with artifacts
   - Push container images to ghcr.io

## Make Targets

Run `make help` to see all available targets. Key targets include:

**Development Setup:**
- `make setup-dev` - Install all development tools and pre-commit hooks
- `make pre-commit-install` - Install pre-commit tool
- `make pre-commit-setup` - Install pre-commit hooks
- `make reuse-install` - Install REUSE tool
- `make reuse-annotate` - Add REUSE headers to all files (interactive)
- `make act-install` - Install act for local workflow testing

**Building & Testing:**
- `make build` - Build the application
- `make test` - Run tests with coverage
- `make test-coverage` - Generate HTML coverage report
- `make lint` - Run golangci-lint
- `make lint-fix` - Run golangci-lint with auto-fix
- `make fmt` - Format code

**Quality Checks:**
- `make pre-commit-run` - Run pre-commit hooks on all files
- `make reuse` - Check REUSE compliance
- `make reuse-spdx` - Generate SPDX bill of materials
- `make vuln` - Check for vulnerabilities
- `make vet` - Run go vet

**Local Workflow Testing:**
- `make act-list` - List all GitHub Actions workflows
- `make act-build` - Test build workflow locally
- `make act-test` - Test test workflow locally
- `make act-lint` - Test linting workflow locally
- `make act-reuse` - Test REUSE workflow locally
- `make act-vuln` - Test vulnerability check locally
- `make act-all` - Run all testable workflows

**Docker:**
- `make docker-build` - Build Docker image
- `make docker-run` - Build and run Docker container

**Release:**
- `make release-snapshot` - Create a snapshot release with GoReleaser

**Maintenance:**
- `make clean` - Clean build artifacts
- `make tidy` - Tidy go.mod
- `make install` - Install dependencies

## Configuration

### golangci-lint

The `.golangci.yaml` file contains comprehensive linting rules including:
- Error checking and handling
- Code style and formatting
- Security checks (gosec)
- Performance optimizations
- Best practices enforcement

### GoReleaser

The `.goreleaser.yaml` file configures:
- Multi-platform binary builds (Linux, macOS, Windows)
- Docker multi-architecture images
- Changelog generation
- Archive creation
- Container registry publishing

## Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

**Quick Start:**
1. Fork the repository
2. Run `make setup-dev` to set up your environment
3. Create a feature branch (`git checkout -b feature/amazing-feature`)
4. Make your changes with appropriate REUSE headers
5. Run `make pre-commit-run` to validate your changes
6. Commit your changes (`git commit -m 'feat: add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Commit Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):
- `feat:` - New features
- `fix:` - Bug fixes
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks
- `refactor:` - Code refactoring
- `test:` - Test updates
- `ci:` - CI/CD changes
- `perf:` - Performance improvements

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### REUSE Compliance

This project follows the [REUSE](https://reuse.software/) specification for copyright and licensing information. All files include SPDX headers or have associated `.license` files.

**Automated Compliance:**
- Pre-commit hooks automatically check REUSE compliance before each commit
- CI/CD workflow validates REUSE compliance on every push and PR

**Manual Checks:**
```bash
# Install REUSE tool (one-time)
make reuse-install

# Check compliance
make reuse

# Generate SPDX bill of materials
make reuse-spdx
```

#### Adding License Headers to New Files

The pre-commit hooks will automatically check for REUSE compliance. You can also annotate files manually:

**Automated annotation:**
```bash
# Annotate a single file
reuse annotate --copyright="OpenCHAMI Contributors" --license="MIT" path/to/file

# Annotate all files in the repository (interactive)
make reuse-annotate

# Download a license file
make reuse-download-license LICENSE=MIT
```

**Manual headers:**

When creating new files, add the following header:

**For Go files:**
```go
// SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors
//
// SPDX-License-Identifier: MIT
```

**For YAML/Markdown/Shell files:**
```yaml
# SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors
#
# SPDX-License-Identifier: MIT
```

**For files that can't have comments (images, binaries, etc.):**
Create a `.license` file with the same name plus `.license` extension, or use `REUSE.toml` for bulk licensing.

## Support

For questions and support, please open an issue in the GitHub repository.

## Related Projects

- [OpenCHAMI](https://github.com/OpenCHAMI)
- [OpenCHAMI GitHub Actions](https://github.com/OpenCHAMI/github-actions)
