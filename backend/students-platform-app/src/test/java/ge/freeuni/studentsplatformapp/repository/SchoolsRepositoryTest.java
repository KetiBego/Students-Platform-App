package ge.freeuni.studentsplatformapp.repository;

import ge.freeuni.studentsplatformapp.model.School;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SchoolsRepositoryTest {

    @Mock
    private SchoolsRepository schoolsRepository;

    @BeforeEach
    void setUp() {
        schoolsRepository.deleteAll();
    }

    @AfterEach
    void tearDown() {
        schoolsRepository.deleteAll();
    }

    @Test
    void testSaveAndFindSchool() {
        School school = new School();
        school.setId(1);
        school.setSchoolName("Test School");
        when(schoolsRepository.save(school)).thenReturn(school);

        School savedSchool = schoolsRepository.save(school);

        assertEquals(school, savedSchool);
    }
}