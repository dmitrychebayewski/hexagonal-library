CREATE TABLE book
(
    id          BIGINT GENERATED BY DEFAULT AS IDENTITY NOT NULL PRIMARY KEY,
    title       VARCHAR(255),
    description VARCHAR(255),
    isbn10      VARCHAR(255),
    price       DOUBLE PRECISION
);