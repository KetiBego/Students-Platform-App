package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.School;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SchoolsRepository extends JpaRepository<School, Long> {
}
