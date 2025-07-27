FROM docker:latest

RUN apk add --no-cache curl bash shadow
COPY exploit.sh /exploit.sh
RUN chmod +x /exploit.sh

CMD ["/bin/sh"]
