FROM ubuntu
WORKDIR /repo
RUN apt-get update && apt-get install -y  curl

