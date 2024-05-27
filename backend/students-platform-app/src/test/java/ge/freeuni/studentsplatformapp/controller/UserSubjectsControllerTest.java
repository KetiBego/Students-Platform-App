package ge.freeuni.studentsplatformapp.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import ge.freeuni.studentsplatformapp.dto.AddUserSubjectRequest;
import ge.freeuni.studentsplatformapp.dto.GetUserSubjectsRequest;
import ge.freeuni.studentsplatformapp.dto.GetUserSubjectsResponse;
import ge.freeuni.studentsplatformapp.model.Subject;
import ge.freeuni.studentsplatformapp.model.User;
import ge.freeuni.studentsplatformapp.repository.SubjectsRepository;
import ge.freeuni.studentsplatformapp.repository.UserRepository;
import ge.freeuni.studentsplatformapp.service.UserSubjectsService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class UserSubjectsControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserSubjectsService userSubjectsService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private SubjectsRepository subjectsRepository;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    void testAddUserSubject() throws Exception {
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
        request.setUserId(user.getId());
        request.setSubjectId(subject.getId());

        mockMvc.perform(post("/user/subjects/add")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());
    }

    @Test
    void testGetUserSubjects() throws Exception {
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

        GetUserSubjectsRequest request = new GetUserSubjectsRequest();
        request.setUserId(user.getId());

        GetUserSubjectsResponse response = new GetUserSubjectsResponse();
        response.setSubjects(Arrays.asList(math, english));

        when(userSubjectsService.getUserSubjects(any(GetUserSubjectsRequest.class))).thenReturn(response);

        mockMvc.perform(get("/user/subjects/get")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());
    }
}
