FROM flyway/flyway:11.6.0
RUN mkdir -p /sql/
COPY *.sql /sql/
COPY run-flyway.sh /run-flyway.sh
RUN chmod +x /run-flyway.sh