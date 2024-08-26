CREATE TABLE IF NOT EXISTS conversations (
    id BIGSERIAL PRIMARY KEY,
    user1_id BIGINT NOT NULL,
    user2_id BIGINT NOT NULL,
    UNIQUE (user1_id, user2_id),
    CONSTRAINT fk_conversations_user1 FOREIGN KEY (user1_id) REFERENCES "USERS"(id),
    CONSTRAINT fk_conversations_user2 FOREIGN KEY (user2_id) REFERENCES "USERS"(id)
);