package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.*;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class UserSubjectsRepositoryTest {

    @Autowired
    private UserSubjectsRepository userSubjectsRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SubjectsRepository subjectsRepository;

    @BeforeEach
    void setUp() {
        userSubjectsRepository.deleteAll();
        userRepository.deleteAll();
        subjectsRepository.deleteAll();
    }

    @AfterEach
    void tearDown() {
        userSubjectsRepository.deleteAll();
        userRepository.deleteAll();
        subjectsRepository.deleteAll();
    }

    @Test
    void testFindByIdUserId() {
        School school = School.builder()
                .schoolName("Freeuni")
                .build();
        User user = User.builder()
                .email("test@freeuni.edu.ge")
                .username("testuser")
                .hashedPassword("password")
                .schoolId(school.getId())
                .build();
        User savedUser = userRepository.save(user);

        Subject math = Subject.builder().id(1L).subjectName("Math").build();
        subjectsRepository.save(math);
        Subject physics = Subject.builder().id(2L).subjectName("Physics").build();
        subjectsRepository.save(physics);

        UserSubjectId userSubjectId1 = new UserSubjectId(user.getId(), math.getId());
        UserSubjectId userSubjectId2 = new UserSubjectId(user.getId(), physics.getId());
        UserSubject userSubject1 = new UserSubject(userSubjectId1);
        UserSubject userSubject2 = new UserSubject(userSubjectId2);
        userSubjectsRepository.save(userSubject1);
        userSubjectsRepository.save(userSubject2);

        List<UserSubject> userSubjects = userSubjectsRepository.findByIdUserId(savedUser.getId());

        assertEquals(2, userSubjects.size());
    }
}
