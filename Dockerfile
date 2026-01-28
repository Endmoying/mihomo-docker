FROM metacubex/mihomo:latest

COPY setenv.py /setenv.py
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN apk add --no-cache curl && \
    mkdir /geox && \
    curl -o /geox/geoip.dat -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.dat && \
    curl -o /geox/geosite.dat -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat && \
    curl -o /geox/country.mmdb -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country.mmdb && \
    curl -o /geox/GeoLite2-ASN.mmdb -L https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb
RUN apk add python3 py3-yaml
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "-d", "/root/.config/clash" ]