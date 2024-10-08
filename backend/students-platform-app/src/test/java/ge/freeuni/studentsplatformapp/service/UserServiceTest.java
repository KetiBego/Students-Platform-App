package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.UserCreateRequest;
import ge.freeuni.studentsplatformapp.dto.UserSignInRequest;
import ge.freeuni.studentsplatformapp.dto.UserSignInResponse;
import ge.freeuni.studentsplatformapp.model.User;
import ge.freeuni.studentsplatformapp.repository.UserRepository;
import ge.freeuni.studentsplatformapp.security.SecurityConfig;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.server.ResponseStatusException;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@SpringBootTest
public class UserServiceTest {

    @MockBean
    private UserRepository userRepository;

    @Autowired
    private UserService userService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    private User user;

    @BeforeEach
    void setUp() {
        user = User.builder()
                .id(1L)
                .email("test@freeuni.edu.ge")
                .username("testuser")
                .hashedPassword(hashPassword())
                .schoolId(123)
                .build();
    }

    @Test
    void testCreateUser() {
        UserCreateRequest request = new UserCreateRequest();
        request.setEmail("test@freeuni.edu.ge");
        request.setUsername("testuser");
        request.setPassword("password");
        request.setSchoolId(123);
        when(userRepository.findByEmail("test@freeuni.edu.ge")).thenReturn(null);

        userService.createUser(request);

        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    void testCreateUserInvalidEmail() {
        UserCreateRequest request = new UserCreateRequest();
        request.setEmail("invalid@example.com");
        request.setUsername("testuser");
        request.setPassword("password");
        request.setSchoolId(123);

        assertThrows(ResponseStatusException.class, () -> userService.createUser(request));
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void testCreateUserEmailExists() {
        UserCreateRequest request = new UserCreateRequest();
        request.setEmail("test@freeuni.edu.ge");
        request.setUsername("testuser");
        request.setPassword("password");
        request.setSchoolId(123);
        when(userRepository.findByEmail("test@freeuni.edu.ge")).thenReturn(user);

        assertThrows(ResponseStatusException.class, () -> userService.createUser(request));
        verify(userRepository, never()).save(any(User.class));
    }

    @Test
    void testSignInUser() {
        UserSignInRequest request = new UserSignInRequest();
        request.setEmail("test@freeuni.edu.ge");
        request.setPassword("password");
        when(userRepository.findByEmail("test@freeuni.edu.ge")).thenReturn(user);

        UserSignInResponse response = userService.signInUser(request);

        assertNotNull(response);
        assertEquals(user.getId(), response.getId());
        assertEquals(user.getEmail(), response.getEmail());
        assertEquals(user.getUsername(), response.getUsername());
    }

    @Test
    void testSignInUserNotFound() {
        UserSignInRequest request = new UserSignInRequest();
        request.setEmail("nonexistent@freeuni.edu.ge");
        request.setPassword("password");
        when(userRepository.findByEmail("nonexistent@freeuni.edu.ge")).thenReturn(null);

        assertThrows(ResponseStatusException.class, () -> userService.signInUser(request));
    }

    @Test
    void testSignInUserIncorrectPassword() {
        UserSignInRequest request = new UserSignInRequest();
        request.setEmail("test@freeuni.edu.ge");
        request.setPassword("wrongpassword");
        when(userRepository.findByEmail("test@freeuni.edu.ge")).thenReturn(user);

        assertThrows(ResponseStatusException.class, () -> userService.signInUser(request));
    }

    private String hashPassword() {
        return passwordEncoder.encode("password");
    }
}
