FROM scratch AS ctx
COPY build_files /

FROM golang:1.26.2-trixie AS go_builder
RUN go install github.com/probeldev/niri-float-sticky@v0.0.8

FROM ghcr.io/ublue-os/bazzite-nvidia-open:stable

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
  --mount=type=cache,dst=/var/cache \
  --mount=type=cache,dst=/var/log \
  --mount=type=tmpfs,dst=/tmp \
  /ctx/00-base.sh && \
  /ctx/10-tooling.sh

COPY --from=go_builder /go/bin/niri-float-sticky /usr/bin/niri-float-sticky

COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
  --mount=type=cache,dst=/var/cache \
  --mount=type=cache,dst=/var/log \
  --mount=type=tmpfs,dst=/tmp \
  /ctx/90-initramfs.sh && \
  /ctx/99-validations.sh

RUN bootc container lint
