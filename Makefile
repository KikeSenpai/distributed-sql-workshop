up: ## Start local warehouse and create buckets
	@docker compose up -d

down: ## Stop local warehouse
	@docker compose down --volumes

trino-cli: ## Access trino-cli
	@docker container exec -it trino-coordinator trino

metadata-db: ## Access metadata in mariadb-cli
	@docker exec -ti mariadb /usr/bin/mariadb -padmin

deps: ## Install dependencies
	@pip install -r requirements.txt
