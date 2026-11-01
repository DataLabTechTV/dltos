ARG USE_ARTIFACT_KEEPER=false

FROM docker.io/library/golang:1.27.1-trixie AS go_builder
RUN go install github.com/probeldev/niri-float-sticky@v0.0.9


FROM docker.io/library/alpine:3.23.4 AS zsh_configs
ENV ANTIDOTE_HOME=/usr/share/zsh/antidote
RUN apk add --no-cache zsh git
RUN git clone --depth=1 https://github.com/mattmc3/antidote.git /antidote
RUN mkdir -p ${ANTIDOTE_HOME}
COPY build_files/zsh_plugins.txt /tmp/zsh_plugins.txt
RUN zsh /antidote/antidote bundle < /tmp/zsh_plugins.txt > ${ANTIDOTE_HOME}/plugins.zsh


FROM ghcr.io/ublue-os/bazzite-nvidia-open:stable
ARG USE_ARTIFACT_KEEPER

COPY system_files/etc/yum.repos.d/artifact-keeper.repo /etc/yum.repos.d/artifact-keeper.repo

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
 dnf5 config-manager setopt keepcache=1

COPY build_files/00-pre-build.sh /tmp/00-pre-build.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    USE_ARTIFACT_KEEPER="${USE_ARTIFACT_KEEPER}" /tmp/00-pre-build.sh

COPY build_files/10-base.sh /tmp/10-base.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/10-base.sh

COPY build_files/20-tooling.sh /tmp/20-tooling.sh
COPY build_files/go-env.sh /tmp/go-env.sh
COPY build_files/cargo-env.sh /tmp/cargo-env.sh
COPY build_files/uv-env.sh /tmp/uv-env.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/20-tooling.sh

COPY --from=go_builder /go/bin/niri-float-sticky /usr/bin/niri-float-sticky
COPY --from=zsh_configs /usr/share/zsh/antidote /usr/share/zsh/antidote
COPY system_files /

COPY build_files/30-services.sh /tmp/30-services.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/30-services.sh

COPY build_files/40-cosmetics.sh /tmp/40-cosmetics.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/40-cosmetics.sh

COPY build_files/50-initramfs.sh /tmp/50-initramfs.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/50-initramfs.sh

COPY build_files/60-validations.sh /tmp/60-validations.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/60-validations.sh

COPY build_files/99-post-build.sh /tmp/99-post-build.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    USE_ARTIFACT_KEEPER="${USE_ARTIFACT_KEEPER}" /tmp/99-post-build.sh

RUN bootc container lint
