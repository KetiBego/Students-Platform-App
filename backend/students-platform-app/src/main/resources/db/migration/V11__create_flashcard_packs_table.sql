CREATE TABLE IF NOT EXISTS flashcard_packs (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(256) NOT NULL,
    subject_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_flashcard_packs_subject FOREIGN KEY (subject_id) REFERENCES subjects(id),
    CONSTRAINT fk_flashcard_packs_creator FOREIGN KEY (user_id) REFERENCES users(id)
);