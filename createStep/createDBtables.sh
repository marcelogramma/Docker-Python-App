#!/bin/bash
#
export PGUSER=postgres
psql <<- SHELL
    CREATE DATABASE russiafly
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;
SHELL
cd /createStepLocal
psql -d russiafly < /createStepLocal/DBTables.sql