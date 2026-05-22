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

COPY build_files /tmp

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/00-base.sh

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/10-tooling.sh

COPY --from=go_builder /go/bin/niri-float-sticky /usr/bin/niri-float-sticky
COPY --from=zsh_configs /usr/share/zsh/antidote /usr/share/zsh/antidote
COPY system_files /

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/20-services.sh

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/30-cosmetics.sh

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/40-initramfs.sh

RUN --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/cache/libdnf5 \
    /tmp/50-validations.sh

RUN bootc container lint
