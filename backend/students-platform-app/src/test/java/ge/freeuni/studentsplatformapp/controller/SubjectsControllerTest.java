package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.SubjectsGetAllResponse;
import ge.freeuni.studentsplatformapp.model.Subject;
import ge.freeuni.studentsplatformapp.service.SubjectsService;
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
public class SubjectsControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private SubjectsService subjectsService;

    @Test
    void testGetSubjects() throws Exception {
        Subject subject1 = new Subject();
        subject1.setId(1L);
        subject1.setSubjectName("Math");

        Subject subject2 = new Subject();
        subject2.setId(2L);
        subject2.setSubjectName("English");

        List<Subject> subjects = Arrays.asList(subject1, subject2);
        SubjectsGetAllResponse response = new SubjectsGetAllResponse(subjects);

        when(subjectsService.getSubjects()).thenReturn(response);

        mockMvc.perform(get("/subjects/all"))
                .andExpect(status().isOk());
    }
}
