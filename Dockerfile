FROM ubuntu:latest

ARG USERNAME=webui
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && apt-get update \
    && apt-get install -y sudo wget git python3 python3-venv libgl1 libglib2.0-0 \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME
# Switch to the default user.
USER $USERNAME

# Global scripts
WORKDIR /home/${USERNAME}}
ENV COMMANDLINE_ARGS="--skip-torch-cuda-test"
COPY install.sh .
RUN bash install.sh

EXPOSE 7860
ENTRYPOINT [ "stable-diffusion-webui/webui.sh" ]
