CREATE TABLE IF NOT EXISTS flashcards (
    id BIGSERIAL PRIMARY KEY,
    pack_id BIGINT NOT NULL,
    question VARCHAR(256) NOT NULL,
    answer TEXT NOT NULL,
    CONSTRAINT fk_flashcard_pack FOREIGN KEY (pack_id) REFERENCES flashcard_packs(id) ON DELETE CASCADE
);