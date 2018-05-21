FROM golang:latest as builder
RUN apt-get update && apt-get install -y
COPY . /go/src/invoicer/
COPY vendor/ /go/src/vendor/
WORKDIR /go/src/invoicer
RUN go install --ldflags '-extldflags "-static"' .

FROM busybox:latest
RUN addgroup -g 10001 app && \
    adduser -G app -u 10001 \
    -D -h /app -s /sbin/nologin app
COPY --from=builder /go/bin/invoicer /app/
USER app
EXPOSE 8080
ENTRYPOINT /app/invoicer
