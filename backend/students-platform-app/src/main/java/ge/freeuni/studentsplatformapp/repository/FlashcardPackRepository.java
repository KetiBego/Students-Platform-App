package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.FlashcardPack;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FlashcardPackRepository extends JpaRepository<FlashcardPack, Long> {
    List<FlashcardPack> findBySubjectIdOrderByCreatedAtDesc(Long subjectId);
}
