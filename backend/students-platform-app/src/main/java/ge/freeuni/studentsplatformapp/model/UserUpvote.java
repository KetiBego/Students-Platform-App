package ge.freeuni.studentsplatformapp.model;

import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "user_upvotes")
public class UserUpvote {
    @EmbeddedId
    private UserUpvoteId id;
}
