package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.Flashcard;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FlashcardRepository extends JpaRepository<Flashcard, Long> {
}
