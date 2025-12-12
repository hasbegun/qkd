# QKD - Quantum Key Distribution Simulator
# Docker-based development and execution

.PHONY: help build build-test run test shell dev dev-test clean logs

# Default target
help:
	@echo "QKD Simulator - Available commands:"
	@echo ""
	@echo "  make build      Build Docker image"
	@echo "  make run        Run BB84 demo"
	@echo "  make test       Run tests"
	@echo "  make shell      Interactive Python shell"
	@echo ""
	@echo "  Development (mounts source, no rebuild needed):"
	@echo "  make dev        Run demo with mounted source"
	@echo "  make dev-test   Run tests with mounted source"
	@echo "  make dev-shell  Interactive shell with mounted source"
	@echo ""
	@echo "  make clean      Remove containers and images"
	@echo "  make logs       Show container logs"

# Build the Docker image
build:
	docker compose build qkd

# Build test image
build-test:
	docker compose build test

# Run the demo
run: build
	docker compose run --rm qkd

# Run tests
test: build-test
	docker compose run --rm test

# Interactive Python shell
shell: build
	docker compose run --rm shell

# Development mode - mount source to avoid rebuilds
dev: build
	docker compose run --rm \
		-v $(PWD)/src:/app/src:ro \
		-v $(PWD)/demo.py:/app/demo.py:ro \
		qkd

# Development tests - mount source
dev-test: build
	docker compose run --rm \
		-v $(PWD)/src:/app/src:ro \
		-v $(PWD)/tests:/app/tests:ro \
		test

# Development shell - mount source (read-write for experiments)
dev-shell: build
	docker compose run --rm \
		-v $(PWD)/src:/app/src \
		-v $(PWD)/tests:/app/tests \
		shell

# Run custom command in dev mode
# Usage: make dev-run CMD="python -c 'from qkd import BB84Protocol; print(BB84Protocol(100).run())'"
dev-run: build
	docker compose run --rm \
		-v $(PWD)/src:/app/src:ro \
		qkd $(CMD)

# Clean up containers and images
clean:
	docker compose down --rmi local --volumes --remove-orphans
	@echo "Cleaned up containers and images"

# Show logs
logs:
	docker compose logs -f
