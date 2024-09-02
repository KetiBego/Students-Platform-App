package ge.freeuni.studentsplatformapp.model;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "user_subjects")
public class UserSubject {
    @EmbeddedId
    private UserSubjectId id;
}
