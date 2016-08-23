FROM ppc64le/ubuntu

ENV DISTRIBUTION_DIR /go/src/github.com/docker/distribution
ENV DOCKER_BUILDTAGS include_oss include_gcs

#RUN set -ex \
#    && apk add --no-cache make git
RUN apt-get update \
&& apt-get install -y wget make git

RUN wget http://ftp.unicamp.br/pub/ppc64el/ubuntu/14_04/cloud-foundry/go-1.6.2-ppc64le.tar.gz \
&& tar zxvf go-1.6.2-ppc64le.tar.gz -C /usr/local \
&& rm go-1.6.2-ppc64le.tar.gz
ENV GOROOT=/usr/local/go
ENV GOPATH=/go
ENV PATH=$PATH:$GOROOT/bin:$GOPATH/bin
WORKDIR $DISTRIBUTION_DIR
COPY . $DISTRIBUTION_DIR
COPY cmd/registry/config-dev.yml /etc/docker/registry/config.yml

RUN make PREFIX=/go clean binaries

VOLUME ["/var/lib/registry"]
EXPOSE 5000
ENTRYPOINT ["registry"]
CMD ["serve", "/etc/docker/registry/config.yml"]
