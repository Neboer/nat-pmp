FROM golang:1.26.3-alpine AS build
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
ARG VERSION=dev
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -ldflags="-s -w -X main.version=${VERSION}" -o /out/nat-pmp .

FROM scratch
COPY --from=build /out/nat-pmp /nat-pmp
ENTRYPOINT ["/nat-pmp"]
CMD ["--config", "/etc/nat-pmp/config.yaml"]
