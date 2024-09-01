package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.AddUserSubjectRequest;
import ge.freeuni.studentsplatformapp.dto.GetUserSubjectsRequest;
import ge.freeuni.studentsplatformapp.dto.GetUserSubjectsResponse;
import ge.freeuni.studentsplatformapp.model.Subject;
import ge.freeuni.studentsplatformapp.model.User;
import ge.freeuni.studentsplatformapp.model.UserSubject;
import ge.freeuni.studentsplatformapp.model.UserSubjectId;
import ge.freeuni.studentsplatformapp.repository.SubjectsRepository;
import ge.freeuni.studentsplatformapp.repository.UserRepository;
import ge.freeuni.studentsplatformapp.repository.UserSubjectsRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
public class UserSubjectsServiceTest {

    @Autowired
    private UserSubjectsRepository userSubjectsRepository;

    @Autowired
    private SubjectsRepository subjectsRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private UserSubjectsService userSubjectsService;

    @BeforeEach
    void setUp() {
        userSubjectsRepository.deleteAll();
        subjectsRepository.deleteAll();
        userRepository.deleteAll();
    }

    @AfterEach
    void tearDown() {
        userSubjectsRepository.deleteAll();
        subjectsRepository.deleteAll();
        userRepository.deleteAll();
    }

    @Test
    void testAddUserSubject() {
        User user = User.builder()
                .email("test@freeuni.edu.ge")
                .username("testuser")
                .hashedPassword("password")
                .schoolId(1)
                .build();
        userRepository.save(user);

        Subject subject = Subject.builder().id(1L).subjectName("Math").build();
        subjectsRepository.save(subject);

        AddUserSubjectRequest request = new AddUserSubjectRequest();
        request.setSubjectId(subject.getId());

        userSubjectsService.addUserSubject(request);

        List<UserSubject> userSubjects = userSubjectsRepository.findByIdUserId(user.getId());
        assertEquals(1, userSubjects.size());
    }

    @Test
    void testGetUserSubjects() {
        User user = User.builder()
                .email("test@freeuni.edu.ge")
                .username("testuser")
                .hashedPassword("password")
                .schoolId(1)
                .build();
        userRepository.save(user);

        Subject math = Subject.builder().id(1L).subjectName("Math").build();
        Subject english = Subject.builder().id(2L).subjectName("English").build();
        subjectsRepository.saveAll(Arrays.asList(math, english));

        UserSubjectId userSubjectId1 = new UserSubjectId(user.getId(), math.getId());
        UserSubjectId userSubjectId2 = new UserSubjectId(user.getId(), english.getId());
        UserSubject userSubject1 = new UserSubject(userSubjectId1);
        UserSubject userSubject2 = new UserSubject(userSubjectId2);
        userSubjectsRepository.saveAll(Arrays.asList(userSubject1, userSubject2));

        GetUserSubjectsRequest request = new GetUserSubjectsRequest();
        request.setUserId(user.getId());

        GetUserSubjectsResponse response = userSubjectsService.getUserSubjects();

        assertEquals(2, response.getSubjects().size());
        assertEquals("Math", response.getSubjects().get(0).getSubjectName());
        assertEquals("English", response.getSubjects().get(1).getSubjectName());
    }
}
