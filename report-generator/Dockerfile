FROM ruby:2.6-alpine

RUN apk update
RUN apk add curl

RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

WORKDIR /app

RUN wget https://storage.googleapis.com/kubernetes-release/release/v1.14.6/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin

COPY update-data.sh .

RUN chown -R appuser:appgroup /app

USER 1000

