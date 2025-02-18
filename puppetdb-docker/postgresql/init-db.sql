CREATE USER puppetdb WITH PASSWORD 'puppetdb';
CREATE USER hme  with PASSWORD 'tcwowa12';
CREATE DATABASE puppetdb OWNER hme;
GRANT CONNECT on DATABASE puppetdb to hme;
SET search_path TO puppetdb;
GRANT USAGE ON SCHEMA public to hme;
                      GRANT CREATE on Schema
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO hme;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO hme;
GRANT ALL PRIVILEGES ON SCHEMA public TO hme;
CREATE EXTENSION pg_trgm;

