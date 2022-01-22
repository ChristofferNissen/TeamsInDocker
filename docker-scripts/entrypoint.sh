#!/bin/bash
set -e
set -x

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}

TEAMS_DESKTOP_USER=cn

install_teams_desktop() {
  echo "Installing teams-wrapper..."
  install -m 0755 /var/cache/teams/teams-wrapper /target/
  install -m 0755 /var/cache/teams/teams-wrapper-two /target/
}

uninstall_teams_desktop() {
  echo "Uninstalling teams-wrapper..."
  rm -rf /target/teams-wrapper
  rm -rf /target/teams-wrapper-two
}

create_user() {
  # create group with USER_GID
  if ! getent group ${TEAMS_DESKTOP_USER} >/dev/null; then
    groupadd -f -g ${USER_GID} ${TEAMS_DESKTOP_USER} >/dev/null 2>&1
  fi

  # create user with USER_UID
  if ! getent passwd ${TEAMS_DESKTOP_USER} >/dev/null; then
    adduser --disabled-login --uid ${USER_UID} --gid ${USER_GID} \
      --gecos 'Teams' ${TEAMS_DESKTOP_USER} >/dev/null 2>&1
  fi
  chown ${TEAMS_DESKTOP_USER}:${TEAMS_DESKTOP_USER} -R /home/${TEAMS_DESKTOP_USER}
}

grant_access_to_video_devices() {
  for device in /dev/video*; do
    if [[ -c $device ]]; then
      VIDEO_GID=$(stat -c %g $device)
      VIDEO_GROUP=$(stat -c %G $device)
      if [[ ${VIDEO_GROUP} == "UNKNOWN" ]]; then
        VIDEO_GROUP=teamsvideo
        groupadd -g ${VIDEO_GID} ${VIDEO_GROUP}
      fi
      usermod -a -G ${VIDEO_GROUP} ${TEAMS_DESKTOP_USER}
      break
    fi
  done
}

launch_teams_desktop() {
  cd /home/${TEAMS_DESKTOP_USER}
  sudo -u ${TEAMS_DESKTOP_USER} teams
  # exec sudo -HEu ${TEAMS_DESKTOP_USER} PULSE_SERVER=/run/pulse/native QT_GRAPHICSSYSTEM="native" $@
  tail -f /home/${TEAMS_DESKTOP_USER}/.config/Microsoft/Microsoft\ Teams/logs/teams-startup.log
  stat /home/${TEAMS_DESKTOP_USER}/.config/Microsoft/Microsoft\ Teams/logs/teams-startup.log
}

case "$1" in
install)
  install_teams_desktop
  ;;
uninstall)
  uninstall_teams_desktop
  ;;
teams)
  create_user
  grant_access_to_video_devices
  echo "$1"
  launch_teams_desktop $@
  ;;
*)
  exec $@
  ;;
esac
