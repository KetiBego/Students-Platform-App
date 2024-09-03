package ge.freeuni.studentsplatformapp.model;

import javax.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
public class UserUpvoteId implements Serializable {
    private Long userId;
    private Long fileId;
}
