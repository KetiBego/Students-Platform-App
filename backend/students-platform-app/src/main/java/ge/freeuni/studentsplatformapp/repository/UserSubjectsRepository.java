package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.UserSubject;
import ge.freeuni.studentsplatformapp.model.UserSubjectId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserSubjectsRepository extends JpaRepository<UserSubject, UserSubjectId> {
    List<UserSubject> findByIdUserId(Long userId);
}
