CREATE TABLE IF NOT EXISTS "USERS" (
    id BIGSERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(255) NOT NULL UNIQUE,
    hashed_password VARCHAR(255) NOT NULL,
    school_id INTEGER,
    CONSTRAINT fk_users_school FOREIGN KEY (school_id) REFERENCES schools(id)
);