CREATE TABLE files (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT,
    subject_id BIGINT,
    file_name VARCHAR(255),
    file_type ENUM('PDF', 'PNG'),
    upvote_count BIGINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    file_data LONGBLOB,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (subject_id) REFERENCES subjects(id)
);