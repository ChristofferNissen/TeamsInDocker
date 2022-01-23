include .env

launch:
	teams-wrapper teams
	teams-wrapper-two teams

kill-containers:
	${CONTAINER_ENGINE} kill teams || podman kill teams-two  # if error try kill other instance before exit
	${CONTAINER_ENGINE} kill teams-two

build:
	${CONTAINER_ENGINE} build -t docker.io/stifstof/teams-desktop:latest -f Containerfile .

build-no-cache:
	${CONTAINER_ENGINE} build --no-cache -t docker.io/stifstof/teams-desktop:latest -f Containerfile .

install:
	${CONTAINER_ENGINE} run -it --rm --privileged \
	--volume ./bin:/target \
	docker.io/stifstof/teams-desktop:latest install

uninstall:
	${CONTAINER_ENGINE} run -it --rm --privileged \
	--volume ./bin:/target \
	docker.io/stifstof/teams-desktop:latest uninstall

# convenience jobs

push:
	echo ${DOCKERHUB_STIFSTOF_PW} | podman login docker.io -u stifstof --password-stdin
	${CONTAINER_ENGINE} push docker.io/stifstof/teams-desktop:latest

reinstall:
	make uninstall
	make build
	make install

create-empty-config-folders:
	mkdir ~/.config/Microsoft
	mkdir ~/.config/MicrosoftTwo

# system setup

add-to-path:
	export PATH=$PATH:/home/cn/Documents/git/TeamsInDocker/bin

podman:
	rm -f .env
	echo "CONTAINER_ENGINE=podman" >> .env

docker:
	rm -f .env
	echo "CONTAINER_ENGINE=docker" >> .env

current_runtime:
	cat .env