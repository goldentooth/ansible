# Multi-stage build for distributed-llama cross-compilation  
FROM ubuntu:22.04 AS builder

# Set build arguments
ARG DISTRIBUTED_LLAMA_VERSION=main
ARG TARGET_ARCH=aarch64-linux-gnu

# Install cross-compilation toolchain and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    git \
    make \
    cmake \
    python3 \
    python3-dev \
    python3-pip \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Create builder user
RUN useradd -m -u 1000 builder
USER builder
WORKDIR /workspace

# Clone distributed-llama repository
RUN git clone --branch ${DISTRIBUTED_LLAMA_VERSION} \
    https://github.com/b4rtaz/distributed-llama.git \
    distributed-llama

WORKDIR /workspace/distributed-llama

# Set up cross-compilation environment
ENV CC=aarch64-linux-gnu-gcc
ENV CXX=aarch64-linux-gnu-g++
ENV AR=aarch64-linux-gnu-ar
ENV STRIP=aarch64-linux-gnu-strip

# Configure for ARM64 build
ENV CFLAGS="-march=armv8-a -mtune=cortex-a72"
ENV CXXFLAGS="-march=armv8-a -mtune=cortex-a72"

# Patch Makefile to replace native flags with ARM64 flags for cross-compilation
RUN sed -i 's/-march=native/-march=armv8-a/g' Makefile && \
    sed -i 's/-mtune=native/-mtune=cortex-a72/g' Makefile

# Build distributed-llama binaries
RUN make dllama CC=${CC} CXX=${CXX}
RUN make dllama-api CC=${CC} CXX=${CXX}

# Create artifacts directory in workspace and copy binaries
RUN mkdir -p /workspace/artifacts/distributed-llama
RUN cp dllama /workspace/artifacts/distributed-llama/dllama-arm64
RUN cp dllama-api /workspace/artifacts/distributed-llama/dllama-api-arm64

# Strip binaries to reduce size
RUN ${STRIP} /workspace/artifacts/distributed-llama/dllama-arm64
RUN ${STRIP} /workspace/artifacts/distributed-llama/dllama-api-arm64

# Create build metadata
RUN echo "Build Date: $(date -Iseconds)" > /workspace/artifacts/distributed-llama/build-info.txt
RUN echo "Version: ${DISTRIBUTED_LLAMA_VERSION}" >> /workspace/artifacts/distributed-llama/build-info.txt
RUN echo "Target: ${TARGET_ARCH}" >> /workspace/artifacts/distributed-llama/build-info.txt
RUN echo "Compiler: $(${CXX} --version | head -1)" >> /workspace/artifacts/distributed-llama/build-info.txt

# Container is ready for artifact extraction - binaries are already built