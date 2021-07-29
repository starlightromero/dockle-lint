buildkit = DOCKER_BUILDKIT=1
compose = docker-compose
date = $$(date +%m%d%H%M%S)
tag = TAG=${date}

build:
	${buildkit} docker build -t dockle-lint:${date} --secret id=passwd,src=passwd.txt .

start:
	${buildkit} docker run --env-file .env -p 8080:8080 --name dockle-lint dockle-lint:${date}

build-compose:
	${buildkit} ${tag} ${compose} build

start-compose:
	${buildkit} ${tag} ${compose} up

stop-compose:
	${compose} down

add-version:
	git add VERSION

commit-version:
	git commit -m "[update] VERSION"

push:
	git push && git push --tags

push-major:
	add-version
	commit-version
	cat VERSION | sed -e "s/[0-9]*[0-9]*\./$$(($$(cat VERSION | sed -e 's/\.[0-9]*[0-9]*//g')+1))./" > VERSION
	push

push-minor:
	add-version
	commit-version
	cat VERSION | sed -e "s/\.[0-9]*[0-9]*\./.$$(($$(cat VERSION | sed -e 's/[0-9]*[0-9]*\.//' -e 's/\.[0-9]*[0-9]*//')+1))./" > VERSION
	push

push-patch:
	add-version
	commit-version
	cat VERSION | sed -e "s/[0-9]*[0-9]*$$/$$(($$(cat VERSION | sed -e 's/[0-9]*[0-9]*\.//g')+1))/" > VERSION
	push
