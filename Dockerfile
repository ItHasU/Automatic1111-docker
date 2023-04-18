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

# Clone repository
RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /home/${USERNAME}/stable-diffusion-webui
WORKDIR /home/${USERNAME}/stable-diffusion-webui

# Remove Cuda dependencies
RUN mkdir venv
RUN python3 -m venv venv
RUN . venv/bin/activate

EXPOSE 7860
ENV COMMANDLINE_ARGS="--skip-torch-cuda-test --precision full --no-half --use-cpu SD GFPGAN BSRGAN ESRGAN SCUNet --all --api"
ENV TORCH_COMMAND="pip install torch==1.13.1 torchvision==0.14.1"
ENTRYPOINT [ "/home/webui/stable-diffusion-webui/webui.sh" ]
