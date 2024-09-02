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
@Entity(name = "schools")
public class School {
    @Id
    private Integer id;

    @Column(name = "school_name", nullable = false)
    private String schoolName;
}
