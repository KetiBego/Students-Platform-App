package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.SchoolsGetAllResponse;
import ge.freeuni.studentsplatformapp.model.School;
import ge.freeuni.studentsplatformapp.repository.SchoolsRepository;
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
public class SchoolsServiceTest {

    @Mock
    private SchoolsRepository schoolsRepository;

    @InjectMocks
    private SchoolsService schoolsService;

    @Test
    void testGetSchools() {
        School school1 = new School();
        school1.setId(1L);
        school1.setSchoolName("Test School 1");

        School school2 = new School();
        school2.setId(2L);
        school2.setSchoolName("Test School 2");

        List<School> schools = Arrays.asList(school1, school2);
        when(schoolsRepository.findAll()).thenReturn(schools);

        SchoolsGetAllResponse response = schoolsService.getSchools();

        assertNotNull(response);
        assertNotNull(response.getSchools());
        assertEquals(2, response.getSchools().size());
        assertTrue(response.getSchools().contains(school1));
        assertTrue(response.getSchools().contains(school2));
    }
}
