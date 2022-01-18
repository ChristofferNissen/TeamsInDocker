FROM debian:latest
LABEL author=stifstof

RUN apt-get update -qy

# General Desktop dependencies not caught by apt-get
RUN apt-get install -qy \
  gvfs-bin \
  libglib2.0-bin \
  trash-cli \
  kde-cli-tools \
  libatspi2.0-0 \
  xdg-utils \
  libxtst6 \
  libxss1 \
  libnss3 \ 
  libnotify4 \ 
  git \
  libayatana-appindicator3-1 \
  libgtk-3-0 \
  libpci-dev \
  firefox-esr \
  wget \
  libgl1 \
  mesa-utils \
  libgl1-mesa-glx

# Install teams and teams specific dependencies
RUN apt-get install -qy \
  curl \
  ca-certificates \
  sudo \
  libxkbfile1 \
  fonts-noto-color-emoji \
  libsecret-1-0 \
  pulseaudio \
  gnupg2 \
  && curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add - \
  && sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list' \
  && apt-get -y update \
  && apt-get -y install teams

# Copy scripts to correct location (/var/cache is host machine)
COPY docker-scripts/xdg-open /usr/local/bin/
COPY host-scripts/ /var/cache/teams/
COPY docker-scripts/entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

# Check version of teams
RUN apt show teams | grep "Version:" && echo ""

ENTRYPOINT ["/sbin/entrypoint.sh"]