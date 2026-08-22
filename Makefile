# Makefile - canonical developer workflow for the repo-template monorepo.
#
# Targets: help, hooks, format, lint, test, build, ci, clean, plus per-stack
# variants (format-rust, lint-typescript, ...). Stack directories are
# auto-detected by marker files (rust/Cargo.toml, typescript/package.json,
# elixir/mix.exs, python/pyproject.toml). Deleting a stack directory requires
# zero edits to this file: its targets print a "[<target>] skipped" message
# and the aggregate targets keep working.
#
# Windows: GNU Make >= 4 is required (install via `choco install make`).
# Recipes are POSIX and need Git Bash (or WSL) in PATH so /bin/bash resolves.

.DEFAULT_GOAL := help
SHELL := /bin/bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

##@ General

help: ## Show this help message
	@awk 'BEGIN {FS = ":.*##"; printf "\033[1mUsage:\033[0m make [target]\n\n"} /^##@/ {printf "\n\033[1m%s\033[0m\n", substr($$0, 5); next} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

format: format-rust format-typescript format-elixir format-python ## Format code in all present stacks
lint: lint-rust lint-typescript lint-elixir lint-python ## Lint all present stacks
test: test-rust test-typescript test-elixir test-python ## Test all present stacks
build: build-rust build-typescript build-elixir build-python ## Build all present stacks
ci: lint test ## Run lint + test (CI gate)
clean: clean-rust clean-typescript clean-elixir clean-python ## Clean build artifacts in all present stacks

##@ Hooks

hooks: ## Install git hooks (pre-commit, commit-msg, pre-push)
	@if ! command -v pre-commit >/dev/null 2>&1; then \
		echo "pre-commit not found - install it with: pipx install pre-commit"; \
		exit 1; \
	else \
		pre-commit install --hook-type pre-commit --hook-type commit-msg --hook-type pre-push; \
	fi

##@ Rust

format-rust: ## Format Rust code (cargo fmt)
	@if [ ! -f rust/Cargo.toml ]; then \
		echo "[format-rust] skipped (no rust/Cargo.toml)"; \
	else \
		cd rust && cargo fmt --all; \
	fi

lint-rust: ## Lint Rust code (cargo fmt --check + clippy -D warnings)
	@if [ ! -f rust/Cargo.toml ]; then \
		echo "[lint-rust] skipped (no rust/Cargo.toml)"; \
	else \
		cd rust && cargo fmt --all -- --check && cargo clippy --all-targets --all-features -- -D warnings; \
	fi

test-rust: ## Test Rust code (cargo-nextest if available, else cargo test)
	@if [ ! -f rust/Cargo.toml ]; then \
		echo "[test-rust] skipped (no rust/Cargo.toml)"; \
	else \
		cd rust && (command -v cargo-nextest >/dev/null 2>&1 && cargo nextest run || cargo test); \
	fi

build-rust: ## Build Rust release binary (cargo build --release)
	@if [ ! -f rust/Cargo.toml ]; then \
		echo "[build-rust] skipped (no rust/Cargo.toml)"; \
	else \
		cd rust && cargo build --release; \
	fi

clean-rust: ## Clean Rust build artifacts (cargo clean)
	@if [ ! -f rust/Cargo.toml ]; then \
		echo "[clean-rust] skipped (no rust/Cargo.toml)"; \
	else \
		cd rust && cargo clean; \
	fi

##@ TypeScript

format-typescript: ## Format TypeScript code (biome format --write)
	@if [ ! -f typescript/package.json ]; then \
		echo "[format-typescript] skipped (no typescript/package.json)"; \
	elif ! command -v pnpm >/dev/null 2>&1; then \
		echo "[format-typescript] skipped (pnpm not installed)"; \
	else \
		pnpm -C typescript run format; \
	fi

lint-typescript: ## Lint TypeScript code (biome check + tsc --noEmit)
	@if [ ! -f typescript/package.json ]; then \
		echo "[lint-typescript] skipped (no typescript/package.json)"; \
	elif ! command -v pnpm >/dev/null 2>&1; then \
		echo "[lint-typescript] skipped (pnpm not installed)"; \
	else \
		pnpm -C typescript run lint && pnpm -C typescript run typecheck; \
	fi

test-typescript: ## Test TypeScript code (vitest run)
	@if [ ! -f typescript/package.json ]; then \
		echo "[test-typescript] skipped (no typescript/package.json)"; \
	elif ! command -v pnpm >/dev/null 2>&1; then \
		echo "[test-typescript] skipped (pnpm not installed)"; \
	else \
		pnpm -C typescript run test; \
	fi

build-typescript: ## Build TypeScript (tsc -p tsconfig.build.json)
	@if [ ! -f typescript/package.json ]; then \
		echo "[build-typescript] skipped (no typescript/package.json)"; \
	elif ! command -v pnpm >/dev/null 2>&1; then \
		echo "[build-typescript] skipped (pnpm not installed)"; \
	else \
		pnpm -C typescript run build; \
	fi

clean-typescript: ## Remove TypeScript artifacts (node_modules, dist, coverage)
	@if [ ! -f typescript/package.json ]; then \
		echo "[clean-typescript] skipped (no typescript/package.json)"; \
	else \
		rm -rf typescript/node_modules typescript/dist typescript/coverage; \
	fi

##@ Elixir

format-elixir: ## Format Elixir code (mix format)
	@if [ ! -f elixir/mix.exs ]; then \
		echo "[format-elixir] skipped (no elixir/mix.exs)"; \
	else \
		cd elixir && mix format; \
	fi

lint-elixir: ## Lint Elixir code (mix format --check-formatted + credo --strict)
	@if [ ! -f elixir/mix.exs ]; then \
		echo "[lint-elixir] skipped (no elixir/mix.exs)"; \
	else \
		cd elixir && mix format --check-formatted && mix credo --strict; \
	fi

test-elixir: ## Test Elixir code (mix test)
	@if [ ! -f elixir/mix.exs ]; then \
		echo "[test-elixir] skipped (no elixir/mix.exs)"; \
	else \
		cd elixir && mix test; \
	fi

build-elixir: ## Compile Elixir project (mix compile)
	@if [ ! -f elixir/mix.exs ]; then \
		echo "[build-elixir] skipped (no elixir/mix.exs)"; \
	else \
		cd elixir && mix compile; \
	fi

clean-elixir: ## Remove Elixir build artifacts (_build, deps)
	@if [ ! -f elixir/mix.exs ]; then \
		echo "[clean-elixir] skipped (no elixir/mix.exs)"; \
	else \
		rm -rf elixir/_build elixir/deps; \
	fi

##@ Python

format-python: ## Format Python code (ruff format)
	@if [ ! -f python/pyproject.toml ]; then \
		echo "[format-python] skipped (no python/pyproject.toml)"; \
	else \
		cd python && uv run ruff format src tests; \
	fi

lint-python: ## Lint Python code (ruff check + ruff format --check)
	@if [ ! -f python/pyproject.toml ]; then \
		echo "[lint-python] skipped (no python/pyproject.toml)"; \
	else \
		cd python && uv run ruff check src tests && uv run ruff format --check src tests; \
	fi

test-python: ## Test Python code (pytest)
	@if [ ! -f python/pyproject.toml ]; then \
		echo "[test-python] skipped (no python/pyproject.toml)"; \
	else \
		cd python && uv run pytest; \
	fi

build-python: ## Build Python package (uv build)
	@if [ ! -f python/pyproject.toml ]; then \
		echo "[build-python] skipped (no python/pyproject.toml)"; \
	else \
		cd python && uv build; \
	fi

clean-python: ## Remove Python caches (pytest, ruff, __pycache__)
	@if [ ! -f python/pyproject.toml ]; then \
		echo "[clean-python] skipped (no python/pyproject.toml)"; \
	else \
		rm -rf python/.pytest_cache python/.ruff_cache; \
		find python -type d -name __pycache__ -prune -exec rm -rf {} +; \
	fi

.PHONY: help hooks format lint test build ci clean \
	format-rust lint-rust test-rust build-rust clean-rust \
	format-typescript lint-typescript test-typescript build-typescript clean-typescript \
	format-elixir lint-elixir test-elixir build-elixir clean-elixir \
	format-python lint-python test-python build-python clean-python
