-- Flyway migration script to (re-)add the 'idx_book_isbn10' index to the 'book' table.
-- This script includes a check to ensure the index does not already exist before
-- attempting to create it, making the migration idempotent.

-- Add the unique index back on the 'isbn10' column from the 'book' table.
-- This index is crucial for optimizing queries that filter or sort by ISBN-10,
-- significantly improving lookup performance for specific books.
-- The IF NOT EXISTS clause prevents an error if the index was somehow
-- manually re-created or already exists from a previous failed run.

-- For PostgreSQL and similar databases (e.g., MySQL 8.0+):
CREATE UNIQUE INDEX IF NOT EXISTS idx_book_isbn10 ON book (isbn10);