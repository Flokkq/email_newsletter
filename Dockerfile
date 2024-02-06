# rust:1.72.0-alpine to create even smaller image
# requires cross compilation (rust-musl-builder)
# also see: https://github.com/johnthagen/min-sized-rust#strip-symbols-from-binary fpr further optimization
FROM lukemathwalker/cargo-chef:latest-rust-1.72.0 as chef
WORKDIR /app
RUN apt update && apt install lld clang -y

FROM chef AS planner
RUN cargo chef prepare --recipe-path recipe.json
COPY . .

FROM chef AS builder
COPY --from=planner /app/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
ENV SQLX_OFFLINE true
RUN cargo build --release --bin email_newsletter

FROM debian:bookworm AS runtime
WORKDIR /app
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends openssl ca-certificates \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/email_newsletter email_newsletter
COPY configuration configuration
ENV APP_ENVIRONMENT production
ENTRYPOINT ["./email_newsletter"]