all: start

start:
		docker compose up -d --build
stop:
		docker compose down
into:
		docker exec -it docker-php56-lumen-apache-php-app-1 bash
