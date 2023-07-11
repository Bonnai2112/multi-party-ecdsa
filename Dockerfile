FROM rust:1.65-buster AS rust

FROM debian:bullseye AS builder

# CLANG
RUN apt-get update
RUN apt-get install -y wget build-essential pkg-config libssl-dev binaryen

RUN printf "deb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye main\ndeb-src http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye main\ndeb http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-12 main\ndeb-src http://apt.llvm.org/bullseye/ llvm-toolchain-bullseye-12 main" >> /etc/apt/sources.list

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN apt-get update
RUN apt-get install -y clang-12
RUN ln -s /usr/bin/clang-12 /usr/bin/clang
RUN clang --version

COPY --from=rust /usr/local/cargo /usr/local/cargo
ENV PATH=/usr/local/cargo/bin:$PATH

# SERVER
COPY . /mpc
RUN rustup default stable
#RUN cargo install --version 0.10.3 wasm-pack
#RUN wasm-pack --version