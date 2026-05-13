FROM scratch AS ctx
COPY build_files /


FROM golang:1.26.2-trixie AS go_builder
RUN go install github.com/probeldev/niri-float-sticky@v0.0.8


FROM alpine:3.23.4 AS zsh_configs
ENV ANTIDOTE_HOME=/usr/share/zsh/antidote
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
  apk add --no-cache zsh git && \
  git clone --depth=1 https://github.com/mattmc3/antidote.git /antidote && \
  mkdir -p ${ANTIDOTE_HOME} && \
  zsh /antidote/antidote bundle < /ctx/zsh_plugins.txt > ${ANTIDOTE_HOME}/plugins.zsh


FROM ghcr.io/ublue-os/bazzite-nvidia-open:stable

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
  --mount=type=cache,dst=/var/cache \
  --mount=type=cache,dst=/var/log \
  --mount=type=tmpfs,dst=/tmp \
  /ctx/00-base.sh && \
  /ctx/10-tooling.sh

COPY --from=go_builder /go/bin/niri-float-sticky /usr/bin/niri-float-sticky

COPY system_files /

COPY --from=zsh_configs /usr/share/zsh/antidote /usr/share/zsh/antidote
RUN --mount=type=bind,from=zsh_configs,source=/,target=/zsh \
  printf "\n# --- antidote bundle ---\n" >> /etc/zsh/plugins.zsh && \
  echo 'source /usr/share/zsh/antidote/plugins.zsh' >> /etc/zsh/plugins.zsh

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
  --mount=type=cache,dst=/var/cache \
  --mount=type=cache,dst=/var/log \
  --mount=type=tmpfs,dst=/tmp \
  /ctx/80-services.sh && \
  /ctx/90-initramfs.sh && \
  /ctx/99-validations.sh

RUN bootc container lint
