# =============================
# BASE IMAGE
# =============================
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# =============================
# SYSTEM DEPENDENCIES
# =============================
RUN apt update && \
    apt install --no-install-recommends -y \
        git \
        vim \
        build-essential \
        python3-dev \
        wget \
        curl \
        bash && \
    rm -rf /var/lib/apt/lists/*

# =============================
# INSTALL MINICONDA
# =============================
WORKDIR /opt/

# Download Miniconda (you forgot this step)
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py310_25.1.1-2-Linux-x86_64.sh

RUN bash Miniconda3-py310_25.1.1-2-Linux-x86_64.sh -b -p /opt/miniconda && \
    rm -f Miniconda3-py310_25.1.1-2-Linux-x86_64.sh

ENV PATH="/opt/miniconda/bin:/opt/text-generation-webui:$PATH"

# =============================
# UPDATE CONDA
# =============================
RUN conda update -n base -c defaults conda -y && \
    conda clean --all --yes && \
    rm -rf /root/.cache/pip

# =============================
# CLONE & INSTALL WEBUI
# =============================
RUN git clone https://github.com/oobabooga/text-generation-webui.git /opt/text-generation-webui
WORKDIR /opt/text-generation-webui

RUN GPU_CHOICE=A LAUNCH_AFTER_INSTALL=FALSE INSTALL_EXTENSIONS=TRUE ./start_linux.sh

RUN chmod +x /opt/text-generation-webui/*.sh \
    && chmod +x /opt/text-generation-webui/*.py 