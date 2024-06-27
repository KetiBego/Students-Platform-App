package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.School;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SchoolsRepository extends JpaRepository<School, Long> {
}
