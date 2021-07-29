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

update-major-version:
	cat VERSION | sed -e "s/[0-9]*[0-9]*\./$$(($$(cat VERSION | sed -e 's/\.[0-9]*[0-9]*//g')+1))./" > VERSION

update-minor-version:
	cat VERSION | sed -e "s/\.[0-9]*[0-9]*\./.$$(($$(cat VERSION | sed -e 's/[0-9]*[0-9]*\.//' -e 's/\.[0-9]*[0-9]*//')+1))./" > VERSION

update-patch-version:
	cat VERSION | sed -e "s/[0-9]*[0-9]*$$/$$(($$(cat VERSION | sed -e 's/[0-9]*[0-9]*\.//g')+1))/" > VERSION

add-version:
	git add VERSION

commit-version:
	git commit -m "[update] VERSION"

tag:
	git tag v$$(cat VERSION)

push:
	git push && git push --tags

push-major: update-major-version add-version commit-version tag push

push-minor: update-minor-version add-version commit-version tag push

push-patch: update-patch-version add-version commit-version tag push
