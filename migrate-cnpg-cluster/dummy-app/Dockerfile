FROM mirror.gcr.io/golang:1.25.1-bookworm AS builder

ENV CGO_ENABLED=0

WORKDIR /go/src/dummy-app


ADD main.go main.go
ADD go.mod go.mod
ADD go.sum go.sum

RUN go build -v -o dummy-app .

FROM scratch AS runtime

COPY <<EOF /etc/group
root:x:0:
nonroot:x:65532:
EOF

COPY <<EOF /etc/passwd
root:x:0:0:root:/root:/sbin/nologin
nonroot:x:65532:65532:nonroot:/home/nonroot:/sbin/nologin
EOF

COPY --from=builder /usr/share/zoneinfo/ /usr/share/zoneinfo/
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /go/src/dummy-app/dummy-app /dummy-app

USER 65532:65532
ENV USER=nonroot

ENTRYPOINT ["/dummy-app"]
