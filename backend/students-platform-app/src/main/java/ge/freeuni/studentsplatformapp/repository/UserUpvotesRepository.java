package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.UserUpvote;
import ge.freeuni.studentsplatformapp.model.UserUpvoteId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UserUpvotesRepository extends JpaRepository<UserUpvote, UserUpvoteId> {
}
