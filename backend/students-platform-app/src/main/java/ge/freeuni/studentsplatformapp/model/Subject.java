package ge.freeuni.studentsplatformapp.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "subjects")
public class Subject {
    @Id
    private Long id;

    @Column(name = "subject_name", nullable = false)
    private String subjectName;
}
