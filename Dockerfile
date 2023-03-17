FROM hashicorp/packer:light

RUN apk upgrade \
    && apk add --no-cache --virtual .run-deps \
       python3 \
       py3-pip\
    && rm -rf /var/cache/apk /root/.cache

RUN adduser -D packer

USER packer
WORKDIR /home/packer

COPY packer.json .
COPY build.sh .
COPY scripts scripts

ENTRYPOINT
CMD ./build.sh
