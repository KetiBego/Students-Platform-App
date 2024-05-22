package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.SubjectsGetAllResponse;
import ge.freeuni.studentsplatformapp.model.Subject;
import ge.freeuni.studentsplatformapp.repository.SubjectsRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
public class SubjectsServiceTest {

    @Mock
    private SubjectsRepository subjectsRepository;

    @InjectMocks
    private SubjectsService subjectsService;

    @Test
    void testGetSubjects() {
        Subject subject1 = new Subject();
        subject1.setId(1L);
        subject1.setSubjectName("Math");

        Subject subject2 = new Subject();
        subject2.setId(2L);
        subject2.setSubjectName("English");

        List<Subject> subjects = Arrays.asList(subject1, subject2);
        when(subjectsRepository.findAll()).thenReturn(subjects);

        SubjectsGetAllResponse response = subjectsService.getSubjects();

        assertNotNull(response);
        assertNotNull(response.getSubjects());
        assertEquals(2, response.getSubjects().size());
        assertTrue(response.getSubjects().contains(subject1));
        assertTrue(response.getSubjects().contains(subject2));
    }
}
