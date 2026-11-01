ARG USE_ARTIFACT_KEEPER=false

FROM docker.io/library/golang:1.27.1-trixie AS go_builder
ENV CGO_ENABLED=0
RUN --mount=type=cache,dst=/go/pkg/mod \
    --mount=type=cache,dst=/root/.cache/go-build \
    go install -trimpath -ldflags='-s -w' github.com/probeldev/niri-float-sticky@v0.0.9


FROM docker.io/library/alpine:3.23.4 AS zsh_configs
ENV ANTIDOTE_HOME=/usr/share/zsh/antidote
RUN apk add --no-cache zsh git
RUN git clone --depth=1 https://github.com/mattmc3/antidote.git /antidote
RUN mkdir -p ${ANTIDOTE_HOME}
COPY build_files/zsh_plugins.txt /tmp/zsh_plugins.txt
RUN zsh /antidote/antidote bundle < /tmp/zsh_plugins.txt > ${ANTIDOTE_HOME}/plugins.zsh


FROM ghcr.io/ublue-os/bazzite-nvidia-open:stable
ARG USE_ARTIFACT_KEEPER

RUN --mount=type=bind,source=build_files/00-pre-build.sh,target=/ctx/00-pre-build.sh \
    --mount=type=bind,source=build_files/artifact-keeper.repo,target=/ctx/artifact-keeper.repo \
    --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    USE_ARTIFACT_KEEPER="${USE_ARTIFACT_KEEPER}" /ctx/00-pre-build.sh

RUN --mount=type=bind,source=build_files/10-base.sh,target=/ctx/10-base.sh \
    --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/10-base.sh

RUN --mount=type=bind,source=build_files/20-tooling.sh,target=/ctx/20-tooling.sh \
    --mount=type=bind,source=build_files/go-env.sh,target=/ctx/go-env.sh \
    --mount=type=bind,source=build_files/cargo-env.sh,target=/ctx/cargo-env.sh \
    --mount=type=bind,source=build_files/uv-env.sh,target=/ctx/uv-env.sh \
    --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/20-tooling.sh

COPY --from=go_builder /go/bin/niri-float-sticky /usr/bin/niri-float-sticky
COPY --from=zsh_configs /usr/share/zsh/antidote /usr/share/zsh/antidote
COPY system_files /

RUN --mount=type=bind,source=build_files/30-services.sh,target=/ctx/30-services.sh \
    --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/30-services.sh

RUN --mount=type=bind,source=build_files/40-cosmetics.sh,target=/ctx/40-cosmetics.sh \
    --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/40-cosmetics.sh

RUN --mount=type=bind,source=build_files/50-initramfs.sh,target=/ctx/50-initramfs.sh \
    --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/50-initramfs.sh

RUN --mount=type=bind,source=build_files/60-validations.sh,target=/ctx/60-validations.sh \
    --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/60-validations.sh

RUN --mount=type=bind,source=build_files/99-post-build.sh,target=/ctx/99-post-build.sh \
    --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    USE_ARTIFACT_KEEPER="${USE_ARTIFACT_KEEPER}" /ctx/99-post-build.sh

RUN bootc container lint
