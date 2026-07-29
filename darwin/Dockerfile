ARG FYNE_CROSS_IMAGES_VERSION=dev
ARG FYNE_CROSS_REPOSITORY=docker.io/fyneio/fyne-cross-images

# fyne-cross image for linux
FROM ${FYNE_CROSS_REPOSITORY}:${FYNE_CROSS_IMAGES_VERSION}-base

# Install Zig
RUN set -eux; \
    rm -rf /usr/local/zig; \
    arch="$(dpkg --print-architecture)"; \
    url=; \
    public_key=${ZIG_MINISIGN_PUBKEY}; \
    case "$arch" in \
        'amd64') \
            arch="x86_64";\
            url="https://ziglang.org/download/${ZIG_VERSION}/zig-${arch}-linux-${ZIG_VERSION}.tar.xz";\
            ;; \
        'arm64') \
            arch="aarch64";\
            url="https://ziglang.org/download/${ZIG_VERSION}/zig-${arch}-linux-${ZIG_VERSION}.tar.xz";\
            ;; \
        *) echo >&2 "error: unsupported architecture '$arch'"; exit 1 ;; \
    esac; \
    curl -sSL ${url} -o zig.tar.xz; \
    curl -sSL ${url}.minisig -o zig.tar.xz.minisig; \
    /usr/local/minisign/${arch}/minisign -Vm zig.tar.xz -P ${public_key}; \
    tar -C /usr/local -Jxvf zig.tar.xz; \
    mv /usr/local/zig-* /usr/local/zig; \
    rm zig.tar*; \
    zig version;

