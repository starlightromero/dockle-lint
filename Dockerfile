# syntax = docker/dockerfile:1.2

FROM golang:1.16.6-alpine as base

SHELL [ "/bin/ash", "-eo", "pipefail", "-c" ]

RUN echo "SHA_CRYPT_MIN_ROUNDS=999999999" > /etc/login.defs

RUN --mount=type=secret,id=passwd echo "root:$(cat /run/secrets/passwd)" | chpasswd -c sha512

RUN sed -ni "1p" /etc/passwd && \
    sed -ni "1p" /etc/shadow && \
    sed -ni "1p" /etc/group

FROM golang:1.16.6-alpine as geolocation

WORKDIR /app

COPY geolocation/go.* .

RUN go mod download

COPY geolocation/* .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build .

FROM golang:1.16.6-alpine as healthcheck

WORKDIR /app

COPY healthcheck/go.* .

RUN go mod download

COPY healthcheck/* .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build .

FROM gcr.io/distroless/static:nonroot

COPY --from=base /etc/passwd /etc/passwd
COPY --from=base /etc/shadow /etc/shadow
COPY --from=base /etc/group /etc/group
COPY --from=geolocation /app/geolocation /usr/bin/geolocation
COPY --from=healthcheck /app/healthcheck /usr/bin/healthcheck

USER 1000

HEALTHCHECK --interval=1s --timeout=1s --start-period=2s --retries=2 CMD [ "healthcheck" ]

ENTRYPOINT [ "/usr/bin/geolocation" ]
