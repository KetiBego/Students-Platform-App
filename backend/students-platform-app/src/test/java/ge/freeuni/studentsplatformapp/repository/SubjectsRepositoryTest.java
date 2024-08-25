package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.Subject;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class SubjectsRepositoryTest {

    @Mock
    private SubjectsRepository subjectsRepository;

    @BeforeEach
    void setUp() {
        subjectsRepository.deleteAll();
    }

    @AfterEach
    void tearDown() {
        subjectsRepository.deleteAll();
    }

    @Test
    void testSaveAndFindSubject() {
        Subject subject = new Subject();
        subject.setId(1L);
        subject.setSubjectName("Math");
        when(subjectsRepository.save(subject)).thenReturn(subject);

        Subject savedSubject = subjectsRepository.save(subject);

        assertEquals(subject, savedSubject);
    }
}
