FROM nginx/nginx-prometheus-exporter:1.5.3 AS exporter

FROM nginx/nginx-unprivileged:stable-alpine

USER root

RUN apk add --no-cache supervisor

COPY --from=exporter \
    /usr/bin/nginx-prometheus-exporter \
    /usr/local/bin/nginx-prometheus-exporter

COPY default.conf.template \
    /etc/nginx/templates/default.conf.template

COPY supervisord.conf /etc/supervisord.conf

USER 101

EXPOSE 8080

CMD ["supervisord", "-n", "-c", "/etc/supervisord.conf"]