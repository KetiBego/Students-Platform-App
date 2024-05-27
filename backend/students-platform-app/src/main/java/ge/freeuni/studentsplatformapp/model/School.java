package ge.freeuni.studentsplatformapp.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "schools")
public class School {
    @Id
    private Integer id;

    @Column(name = "school_name", nullable = false)
    private String schoolName;
}
