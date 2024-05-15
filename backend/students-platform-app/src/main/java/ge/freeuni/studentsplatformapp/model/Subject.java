package ge.freeuni.studentsplatformapp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;

@Data
@Entity(name = "subjects")
public class Subject {
    @Id
    private Long id;

    @Column(name = "subject_name", nullable = false)
    private String subjectName;
}
