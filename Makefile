launch:
	teams-wrapper teams
	teams-wrapper-two teams

kill-containers:
	podman kill teams || podman kill teams-two  # if error try kill other instance before exit
	podman kill teams-two

build:
	podman build . -t docker.io/stifstof/teams-desktop:latest

install:
	podman run -it --rm --privileged \
	--volume ./bin:/target \
	docker.io/stifstof/teams-desktop:latest install

uninstall:
	podman run -it --rm --privileged \
	--volume ./bin:/target \
	docker.io/stifstof/teams-desktop:latest uninstall

push:
	podman push docker.io/stifstof/teams-desktop:latest

# convenience jobs

reinstall:
	make uninstall
	make build
	make install

create-empty-config-folders:
	mkdir ~/.config/Microsoft
	mkdir ~/.config/MicrosoftTwo

add-to-path:
	export PATH=$PATH:~/Documents/git/TeamsInDocker/bin