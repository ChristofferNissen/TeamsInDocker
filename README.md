# Microsoft Teams in Container
![](https://i.imgur.com/pVwxCtz.png)

This projects objective is to provide Microsoft Teams as a container to enable multiple accounts to be used simultaniously.

Currently the project supports Docker and Podman. Select which runtime you want with the convenient make targets:

Makefile (System setup)
- docker
- podman
- current_runtime

The default runtime is Docker. Select podman with "make podman" and confirm with "make current_runtime".

The Makefile contains the relevant commands to use the application. The project works with two accounts, but can be extended to any number of accounts (not tested).

Teams is not the most stable application, so you can expect to get familiar with the two first commands in the Maefile:

Makefile
- launch
- kill-containers
- install
- uninstall
- build

# Old Readme

This project is inspired from te works of gfa01/slack-desktop, but instead for Microsoft Teams. The old README explains the use of PulseAudio and XServer well

You can find the README from the project which this is based on in the folder Old/

## To get up and running

Ensure you have two Microsoft configurations in ~/.config, mine are named Microsoft and MicrosoftTwo

Either use the images i pushed to dockerhub by directly running

```
make install
make launch
```

and two Microsoft Teams applications should appear on your screen.

Do you wish to modify the image, you can change the image name in the scripts in the scripts/ folder.


## Uninstall

Simply run

```
make kill-containers
make uninstall
```
