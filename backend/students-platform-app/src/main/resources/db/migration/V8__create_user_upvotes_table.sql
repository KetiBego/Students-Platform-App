CREATE TABLE IF NOT EXISTS user_upvotes (
    user_id BIGINT NOT NULL,
    file_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, file_id),
    CONSTRAINT fk_user_upvotes_user FOREIGN KEY (user_id) REFERENCES "USERS"(id),
    CONSTRAINT fk_user_upvotes_file FOREIGN KEY (file_id) REFERENCES files(id) ON DELETE CASCADE
);