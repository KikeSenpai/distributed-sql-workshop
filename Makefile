up: ## Start local warehouse
	@docker volume rm --force minio-data
	@docker compose up -d --build

down: ## Stop local warehouse
	@docker compose down

trino-cli: ## Access trino-cli
	@docker container exec -it trino-coordinator trino

metadata-db: ## Access metadata in mariadb-cli
	@docker exec -ti mariadb /usr/bin/mariadb -padmin

