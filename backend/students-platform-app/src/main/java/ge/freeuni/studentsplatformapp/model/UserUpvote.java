package ge.freeuni.studentsplatformapp.model;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
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
