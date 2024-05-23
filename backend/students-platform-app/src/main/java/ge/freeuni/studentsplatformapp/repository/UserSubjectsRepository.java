package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.UserSubject;
import ge.freeuni.studentsplatformapp.model.UserSubjectId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserSubjectsRepository extends JpaRepository<UserSubject, UserSubjectId> {
    List<UserSubject> findByIdUserId(Long userId);
}
