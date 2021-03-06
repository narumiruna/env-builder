ARG BASE_IMAGE
FROM $BASE_IMAGE

# Install jupyter notebook
RUN if [ -n "$(which python3)" ]; then python3 -m pip install jupyter; \
    elif [ -n "$(which python)" ]; then python -m pip install jupyter; fi

# Install all OS dependencies for notebook server that starts but lacks all
# features (e.g., download as all possible file formats)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    locales \
    netcat \
    sudo \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Configure environment
ENV SHELL=/bin/bash \
    USER_NAME=narumi \
    GROUP_NAME=narumi \
    USER_ID=1000 \
    GROUP_ID=2000 \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Create aurora user with UID=1000 and in the 'aurora' group
RUN groupadd -g $GROUP_ID $GROUP_NAME \
    && useradd -m -s $SHELL -N -u $USER_ID -g $GROUP_ID $USER_NAME \
    && echo $USER_NAME 'ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 8888
WORKDIR /workspace

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY jupyter_notebook_config.py /etc/jupyter/

# Install Aurora job submit tool
ARG CACHE_DATE
ARG SUBMIT_TOOL_NAME=aurora
RUN wget https://raw.githubusercontent.com/linkernetworks/aurora/master/install.sh -O - | bash \
    && if [ "$SUBMIT_TOOL_NAME" != "aurora" ]; then mv /usr/local/bin/aurora /usr/local/bin/$SUBMIT_TOOL_NAME; fi

# Configure container startup
CMD ["start-notebook.sh"]
