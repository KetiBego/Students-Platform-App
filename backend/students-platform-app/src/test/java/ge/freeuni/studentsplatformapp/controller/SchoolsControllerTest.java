package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.SchoolsGetAllResponse;
import ge.freeuni.studentsplatformapp.model.School;
import ge.freeuni.studentsplatformapp.service.SchoolsService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;

import java.util.Arrays;
import java.util.List;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class SchoolsControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private SchoolsService schoolsService;

    @Test
    void testGetSchools() throws Exception {
        School school1 = new School();
        school1.setId(1);
        school1.setSchoolName("Test School 1");

        School school2 = new School();
        school2.setId(2);
        school2.setSchoolName("Test School 2");

        List<School> schools = Arrays.asList(school1, school2);
        SchoolsGetAllResponse response = new SchoolsGetAllResponse();
        response.setSchools(schools);

        when(schoolsService.getSchools()).thenReturn(response);

        mockMvc.perform(get("/schools/all"))
                .andExpect(status().isOk());
    }
}
