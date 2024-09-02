package ge.freeuni.studentsplatformapp.model;

import javax.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "files")
public class File {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "subject_id", nullable = false)
    private Long subjectId;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "file_type")
    @Enumerated(EnumType.STRING)
    private FileType fileType;

    @Column(name = "upvote_count", nullable = false)
    private Long upvoteCount;

    @Column(name = "created_at", nullable = false)
    private Timestamp createdAt;

    @Lob
    @Column(name = "file_data")
    private byte[] fileData;
}
