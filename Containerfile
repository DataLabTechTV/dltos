FROM docker.io/library/golang:1.26.2-trixie AS go_builder
RUN go install github.com/probeldev/niri-float-sticky@v0.0.8


FROM docker.io/library/alpine:3.23.4 AS zsh_configs
ENV ANTIDOTE_HOME=/usr/share/zsh/antidote
RUN apk add --no-cache zsh git
RUN git clone --depth=1 https://github.com/mattmc3/antidote.git /antidote
RUN mkdir -p ${ANTIDOTE_HOME}
COPY build_files/zsh_plugins.txt /tmp/zsh_plugins.txt
RUN zsh /antidote/antidote bundle < /tmp/zsh_plugins.txt > ${ANTIDOTE_HOME}/plugins.zsh


FROM ghcr.io/ublue-os/bazzite-nvidia-open:stable
# FROM ghcr.io/ublue-os/bazzite-nvidia-open:stable-44.20260825
# FROM ghcr.io/ublue-os/bazzite-nvidia-open:testing-44.20260904@sha256:47357a1b70537e81b6d1a7af0e708d39b636abbcc179bb4d8c383ea459f97bf6

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
 dnf5 config-manager setopt keepcache=1

COPY build_files/00-base.sh /tmp/00-base.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/00-base.sh

COPY build_files/10-tooling.sh /tmp/10-tooling.sh
COPY build_files/go-env.sh /tmp/go-env.sh
COPY build_files/cargo-env.sh /tmp/cargo-env.sh
COPY build_files/uv-env.sh /tmp/uv-env.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/10-tooling.sh

COPY --from=go_builder /go/bin/niri-float-sticky /usr/bin/niri-float-sticky
COPY --from=zsh_configs /usr/share/zsh/antidote /usr/share/zsh/antidote
COPY system_files /

COPY build_files/20-services.sh /tmp/20-services.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/20-services.sh

COPY build_files/30-cosmetics.sh /tmp/30-cosmetics.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/30-cosmetics.sh

COPY build_files/40-initramfs.sh /tmp/40-initramfs.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/40-initramfs.sh

COPY build_files/50-validations.sh /tmp/50-validations.sh
RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/50-validations.sh

RUN bootc container lint
