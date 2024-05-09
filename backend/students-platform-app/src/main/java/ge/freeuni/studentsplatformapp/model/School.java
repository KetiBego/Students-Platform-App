package ge.freeuni.studentsplatformapp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.Data;

@Data
@Entity(name = "schools")
public class School {
    @Id
    private Long id;

    @Column(name = "school_name", nullable = false)
    private String schoolName;
}
