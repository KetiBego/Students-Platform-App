package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.File;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FileRepository extends JpaRepository<File, Long> {
    List<File> findByUserIdOrderByUpvoteCountDescCreatedAtDesc(Long userId);
    List<File> findBySubjectIdOrderByUpvoteCountDescCreatedAtDesc(Long subjectId);
}
