FROM registry.hub.docker.com/flyway/flyway
RUN mkdir -p /sql/
COPY *.sql /sql/
COPY run-flyway.sh /run-flyway.sh
RUN chmod +x /run-flyway.sh