launch:
	teams-wrapper teams
	teams-wrapper-two teams

kill-containers:
	docker kill teams || docker kill teams-two  # if error try kill other instance before exit
	docker kill teams-two

build:
	docker build . -t stifstof/teams-desktop:latest

install:
	docker run -it --rm \
	--volume /usr/local/bin:/target \
	stifstof/teams-desktop:latest install

uninstall:
	docker run -it --rm \
	--volume /usr/local/bin:/target \
	stifstof/teams-desktop:latest uninstall

# convenience jobs

reinstall:
	make uninstall
	make build
	make install

create-empty-config-folders:
	mkdir ~/.config/Microsoft
	mkdir ~/.config/MicrosoftTwo