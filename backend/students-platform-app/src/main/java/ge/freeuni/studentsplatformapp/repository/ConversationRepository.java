package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ConversationRepository extends JpaRepository<Conversation, Long> {
    Conversation findByUser1IdAndUser2Id(Long user1Id, Long user2Id);
    List<Conversation> findByUser1IdOrUser2Id(Long user1Id, Long user2Id);
}
