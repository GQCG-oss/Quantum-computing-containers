FROM continuumio/miniconda3:22.11.1
# non interactive frontend for locales
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential wget make git procps locales curl openssh-client python3 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get autoremove -y

# generating locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

COPY ./requirements.txt /tmp/
RUN pip install --requirement /tmp/requirements.txt

RUN pip install jupyter
RUN pip install git+https://github.com/tequilahub/tequila.git
RUN conda update --force conda -y 
RUN conda install psi4 python=3.10 -c conda-forge -y

ENTRYPOINT bash
