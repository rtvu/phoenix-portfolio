##############
# Base Image #
##############

FROM rtvu/elixir

########################
# Setup User Workspace #
########################

RUN \
  mkdir ${HOME}/workspace && \
  git config --global --add safe.directory ${HOME}/workspace

###################
# Install Phoenix #
###################

RUN \
  sudo apt update && \
  sudo DEBIAN_FRONTEND=noninteractive apt install --yes --no-install-recommends \
    inotify-tools \
    && \
  sudo rm -rf /var/lib/apt/lists/* && \
  /bin/bash -c '. $HOME/.asdf/asdf.sh && mix archive.install --force hex phx_new'

###########
# Startup #
###########

WORKDIR ${HOME}/workspace

CMD ["/bin/bash"]
