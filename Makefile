all: start

start:
		docker compose up -d --build
stop:
		docker compose down
into:
		docker exec -it php-app-1 bash
