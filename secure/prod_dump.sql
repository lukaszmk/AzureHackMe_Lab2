-- AzureHackMe Lab 2 Mock Database Backup
CREATE TABLE users (
    id INT PRIMARY KEY,
    username VARCHAR(50),
    password_hash VARCHAR(255)
);

INSERT INTO users VALUES (1, 'admin', '$2b$12$K3v8x9Y2mNzP9qR...MOCK_HASH');
INSERT INTO users VALUES (2, 'db_admin', '$2b$12$9xP2mNzP9qRK3v8...MOCK_HASH');