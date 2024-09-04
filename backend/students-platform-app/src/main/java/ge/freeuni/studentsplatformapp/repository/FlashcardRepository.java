package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.Flashcard;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface FlashcardRepository extends JpaRepository<Flashcard, Long> {
    List<Flashcard> findByPackId(Long packId);
}
