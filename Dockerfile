# syntax=docker/dockerfile:1

FROM --platform=$TARGETPLATFORM rust:slim-bookworm AS builder

WORKDIR /usr/src/gping

COPY gping/ gping/
COPY pinger/ pinger/
COPY Cargo.* ./

RUN cargo install --locked --path ./gping 


FROM --platform=$TARGETPLATFORM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y iputils-ping \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/cargo/bin/gping /usr/local/bin/gping

ENTRYPOINT ["gping"]
