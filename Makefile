.PHONY: help install bootstrap check requirements

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

requirements: ## Install Ansible requirements
	ansible-galaxy install -r requirements.yml

install: requirements bootstrap ## Install requirements and run bootstrap

bootstrap: ## Run the macOS bootstrap playbook
	ansible-playbook bootstrap.yml --ask-become-pass

check: ## Check the playbook syntax
	ansible-playbook bootstrap.yml --syntax-check

dry-run: ## Run the playbook in check mode (dry run)
	ansible-playbook bootstrap.yml --check --ask-become-pass