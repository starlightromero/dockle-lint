buildkit = DOCKER_BUILDKIT=1
compose = docker-compose
tag = TAG=$$(date +%m%d%H%M%S)

build:
	${buildkit} docker build -t dockle-lint --secret id=passwd,src=passwd.txt .

start:
	${buildkit} docker run --env-file .env -p 8080:8080 --name dockle-lint dockle-lint

build-compose:
	TAG=$$(date +%m%d%H%M%S) ${compose} build

start-compose:
	TAG=$$(date +%m%d%H%M%S) ${compose} up

stop-compose:
	${compose} down