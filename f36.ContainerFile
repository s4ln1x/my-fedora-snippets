FROM quay.io/fedora/fedora:36

LABEL maintainer Salvador Gudino <cero@duck.com>

ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USER_NAME=fedora-packager
ARG USER_PASSWORD=fedora-password
ARG HOME=/home/fedora-packager
ARG FAS_ID=fedora-packager

USER root

# Install fedora packager tools
RUN dnf install -y fedora-packager \
                   fedora-review \
                   sudo \
    && dnf clean all \
    && rm -rf /var/cache/yum

# Add development user
RUN groupadd --gid "${GROUP_ID}" "${USER_NAME}" \
    && useradd -l \
        --uid "${USER_ID}" \
        --gid "${GROUP_ID}" \
        --groups wheel \
        --home-dir "${HOME}" \
        --create-home \
        --shell /bin/bash \
        "${USER_NAME}" \
    && echo "${USER_NAME}":"${USER_PASSWORD}" | chpasswd

RUN usermod -a -G mock "${USER_NAME}"

USER "${USER_NAME}"
WORKDIR "${HOME}"
CMD [ "bash" ]

# Inside the container run fkinit -u <your_fas_id> to get kerberos ticket or kinit -R to renew
# Podman image created based on https://docs.fedoraproject.org/en-US/package-maintainers/Installing_Packager_Tools/
