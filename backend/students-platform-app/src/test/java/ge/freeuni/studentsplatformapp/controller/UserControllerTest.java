package ge.freeuni.studentsplatformapp.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import ge.freeuni.studentsplatformapp.dto.UserCreateRequest;
import ge.freeuni.studentsplatformapp.dto.UserSignInRequest;
import ge.freeuni.studentsplatformapp.dto.UserSignInResponse;
import ge.freeuni.studentsplatformapp.service.UserService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserService userService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Test
    void testCreateUser() throws Exception {
        UserCreateRequest request = new UserCreateRequest();
        request.setEmail("test@freeuni.edu.ge");
        request.setUsername("testuser");
        request.setPassword("password");
        request.setSchoolId(123);

        mockMvc.perform(post("/user/create")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());
    }

    @Test
    void testSignInUser() throws Exception {
        UserSignInRequest request = new UserSignInRequest();
        request.setEmail("test@freeuni.edu.ge");
        request.setPassword("password");

        UserSignInResponse response = new UserSignInResponse();
        response.setId(1L);
        response.setEmail("test@freeuni.edu.ge");
        response.setUsername("testuser");

        when(userService.signInUser(request)).thenReturn(response);

        mockMvc.perform(post("/user/signIn")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());
    }
}
