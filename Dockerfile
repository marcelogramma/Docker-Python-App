FROM postgres:13.3
EXPOSE 5432

RUN apt-get update && \
    apt-get -y install dos2unix binutils

RUN mkdir /createStepLocal
COPY /createStep/. /createStepLocal/
RUN cp /createStepLocal/createDBtables.sh /docker-entrypoint-initdb.d/ && \
    dos2unix /docker-entrypoint-initdb.d/*.sh