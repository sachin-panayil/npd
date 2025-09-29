# Makefile

# Default target
.PHONY: test clean

test:
	@echo "Running tests..."
	@docker-compose -f docker-compose-test.yml up -d db-test db-migrations
	@docker-compose -f docker-compose-test.yml up --build django-test
	@echo "Tests completed!"

clean:
	@echo "Cleaning up cache files..."
	@find . -type d -name "__pycache__" -exec rm -rf {} +
	@rm -rf artifacts/
	@echo "Cleanup done."
