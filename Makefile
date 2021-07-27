compose = docker-compose

build:
	TAG=$$(date +%m%d%H%M%S) ${compose} build

start:
	TAG=$$(date +%m%d%H%M%S) ${compose}

stop:
	${compose} down
