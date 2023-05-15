# Api Travels

## DB

> Run:
>
> - add file 'database.yml'
> - sudo su - postgres
> - psql
> - CREATE DATABASE travels_api OWNER user;
> - CREATE TABLE users (id SERIAL PRIMARY KEY, name VARCHAR(255),email VARCHAR(255) NOT NULL UNIQUE, status INTEGER DEFAULT 0 NOT NULL,role integer,created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, pay VARCHAR(255));
> - CREATE TABLE travels (id SERIAL PRIMARY KEY,rider_id INTEGER NOT NULL REFERENCES users(id),driver_id INTEGER REFERENCES users(id),lat_start FLOAT NOT NULL,long_start FLOAT NOT NULL,lat_end FLOAT,long_end FLOAT,status INTEGER NOT NULL,created_at TIMESTAMP DEFAULT NOW(),updated_at TIMESTAMP DEFAULT NOW(), cost INTEGER DEFAULT 0);
> - INSERT INTO users (name, email, pay, role, status, created_at, updated_at) VALUES ('Alex', 'ale1@example.com', NULL, 0, 0, NOW(), NOW());
> - INSERT INTO users (name, email, pay, role, status, created_at, updated_at) VALUES ('David', 'david1@example.com', NULL, 1, 0, NOW(), NOW());
> - INSERT INTO users (name, email, pay, role, status, created_at, updated_at) VALUES ('David', 'david2@example.com', NULL, 1, 0, NOW(), NOW());

## Development server

> Run:
>
> - bundle i
> - bundle exec rackup config.ru
> -
> -
> -
