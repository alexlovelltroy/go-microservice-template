# SPDX-FileCopyrightText: 2025 OpenCHAMI Contributors
#
# SPDX-License-Identifier: MIT

.PHONY: help build test lint clean install run docker-build docker-run

# Variables
BINARY_NAME=app
GO=go
GOFLAGS=-v
LDFLAGS=-ldflags "-X main.version=$(VERSION) -X main.commit=$(shell git rev-parse --short HEAD) -X main.date=$(shell date -u +%Y-%m-%dT%H:%M:%SZ)"

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the application
	$(GO) build $(GOFLAGS) $(LDFLAGS) -o bin/$(BINARY_NAME) .

test: ## Run tests
	$(GO) test $(GOFLAGS) -race -coverprofile=coverage.out -covermode=atomic ./...

test-coverage: test ## Run tests with coverage report
	$(GO) tool cover -html=coverage.out -o coverage.html
	@echo "Coverage report generated: coverage.html"

lint: ## Run golangci-lint
	golangci-lint run

lint-fix: ## Run golangci-lint with auto-fix
	golangci-lint run --fix

clean: ## Clean build artifacts
	rm -rf bin/ dist/ coverage.out coverage.html
	$(GO) clean

install: ## Install dependencies
	$(GO) mod download
	$(GO) mod verify

tidy: ## Tidy go.mod
	$(GO) mod tidy

run: build ## Build and run the application
	./bin/$(BINARY_NAME)

docker-build: ## Build Docker image
	docker build -t $(BINARY_NAME):latest .

docker-run: docker-build ## Build and run Docker container
	docker run --rm $(BINARY_NAME):latest

release-snapshot: ## Create a snapshot release with GoReleaser
	goreleaser release --snapshot --clean

fmt: ## Format code
	$(GO) fmt ./...
	goimports -w .

vet: ## Run go vet
	$(GO) vet ./...

vuln: ## Check for vulnerabilities
	govulncheck ./...

reuse: ## Check REUSE compliance
	reuse lint

reuse-spdx: ## Generate SPDX bill of materials
	reuse spdx -o reuse.spdx

reuse-install: ## Install REUSE tool
	@command -v pipx >/dev/null 2>&1 || { echo "pipx is required but not installed. Install it with: python3 -m pip install --user pipx"; exit 1; }
	pipx install reuse
	@echo "REUSE tool installed successfully"

reuse-annotate: ## Add REUSE headers to all files in the repository
	@echo "Annotating files with REUSE headers..."
	@echo "This will add SPDX headers to files that don't have them yet."
	@read -p "Copyright holder [OpenCHAMI Contributors]: " holder; \
	holder=$${holder:-OpenCHAMI Contributors}; \
	read -p "License [MIT]: " license; \
	license=$${license:-MIT}; \
	read -p "Year [$(shell date +%Y)]: " year; \
	year=$${year:-$(shell date +%Y)}; \
	echo "Annotating with: SPDX-FileCopyrightText: $$year $$holder"; \
	echo "                 SPDX-License-Identifier: $$license"; \
	reuse annotate --copyright="$$holder" --license="$$license" --year="$$year" --skip-existing --recursive .

reuse-download-license: ## Download a license file (usage: make reuse-download-license LICENSE=MIT)
	@if [ -z "$(LICENSE)" ]; then \
		echo "Error: LICENSE variable is required. Usage: make reuse-download-license LICENSE=MIT"; \
		exit 1; \
	fi
	reuse download $(LICENSE)

pre-commit-install: ## Install pre-commit tool
	@command -v pipx >/dev/null 2>&1 || { echo "pipx is required but not installed. Install it with: python3 -m pip install --user pipx"; exit 1; }
	pipx install pre-commit
	@echo "pre-commit installed successfully"

pre-commit-setup: ## Install pre-commit hooks
	@command -v pre-commit >/dev/null 2>&1 || { echo "pre-commit is not installed. Run 'make pre-commit-install' first."; exit 1; }
	pre-commit install
	pre-commit install --hook-type commit-msg
	@echo "pre-commit hooks installed successfully"

pre-commit-run: ## Run pre-commit hooks on all files
	pre-commit run --all-files

pre-commit-update: ## Update pre-commit hooks to latest versions
	pre-commit autoupdate

setup-dev: reuse-install pre-commit-install pre-commit-setup ## Set up development environment (install tools and hooks)
	@echo ""
	@echo "Development environment setup complete!"
	@echo "Next steps:"
	@echo "  1. Run 'make reuse-annotate' to add REUSE headers to all files"
	@echo "  2. Run 'make pre-commit-run' to test pre-commit hooks"
	@echo "  3. Start coding! Pre-commit hooks will run automatically on git commit"

all: clean install lint test build ## Run all checks and build

.DEFAULT_GOAL := help
