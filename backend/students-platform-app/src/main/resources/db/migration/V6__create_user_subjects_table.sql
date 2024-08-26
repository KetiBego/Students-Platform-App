CREATE TABLE IF NOT EXISTS user_subjects (
    user_id BIGINT NOT NULL,
    subject_id BIGINT NOT NULL,
    PRIMARY KEY (user_id, subject_id),
    CONSTRAINT fk_user_subjects_user FOREIGN KEY (user_id) REFERENCES "USERS"(id),
    CONSTRAINT fk_user_subjects_subject FOREIGN KEY (subject_id) REFERENCES subjects(id)
);