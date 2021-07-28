# syntax = docker/dockerfile:1.2

FROM golang:1.16.6-alpine as build

SHELL [ "/bin/ash", "-eo", "pipefail", "-c" ]

RUN echo "SHA_CRYPT_MIN_ROUNDS=999999999" > /etc/login.defs

RUN --mount=type=secret,id=passwd echo "root:$(cat /run/secrets/passwd)" | chpasswd -c sha512

RUN sed -ni "1p" /etc/passwd && \
    sed -ni "1p" /etc/shadow && \
    sed -ni "1p" /etc/group

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build .

FROM gcr.io/distroless/static:nonroot

COPY --from=build /app/geolocation /usr/bin/geolocation
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/shadow /etc/shadow
COPY --from=build /etc/group /etc/group

USER 1000

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=2 CMD curl -f http://localhost/ || exit 1

ENTRYPOINT ["/usr/bin/geolocation"]
