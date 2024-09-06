package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.Flashcard;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FlashcardRepository extends JpaRepository<Flashcard, Long> {
    List<Flashcard> findByPackId(Long packId);
}
