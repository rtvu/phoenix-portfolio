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

###################
# Install Node.js #
###################

RUN \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && \
  NODE_VERSION=20.15.1 /bin/bash -c 'source ${HOME}/.nvm/nvm.sh && nvm install ${NODE_VERSION}' && \
  NODE_VERSION=20.15.1 /bin/bash -c 'source ${HOME}/.nvm/nvm.sh && nvm alias default ${NODE_VERSION}' && \
  /bin/bash -c 'source ${HOME}/.nvm/nvm.sh && nvm use default' && \
  /bin/bash -c 'source ${HOME}/.nvm/nvm.sh && corepack enable'

###########
# Startup #
###########

ENV SHELL=/bin/bash

WORKDIR ${HOME}/workspace

CMD ["/bin/bash"]
