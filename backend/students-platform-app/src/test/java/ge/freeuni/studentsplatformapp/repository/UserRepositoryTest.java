package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.User;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class UserRepositoryTest {

    @Mock
    private UserRepository userRepository;

    @Test
    void testFindByEmail() {
        User user = User.builder()
                .id(1L)
                .email("test@example.com")
                .username("testuser")
                .hashedPassword("hashedpassword")
                .schoolId(123)
                .build();
        when(userRepository.findByEmail("test@example.com")).thenReturn(user);

        User foundUser = userRepository.findByEmail("test@example.com");

        assertEquals(user, foundUser);
    }
}
