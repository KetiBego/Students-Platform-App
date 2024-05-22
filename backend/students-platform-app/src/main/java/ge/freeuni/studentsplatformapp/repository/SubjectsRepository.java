package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.Subject;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SubjectsRepository extends JpaRepository<Subject, Long> {
}
