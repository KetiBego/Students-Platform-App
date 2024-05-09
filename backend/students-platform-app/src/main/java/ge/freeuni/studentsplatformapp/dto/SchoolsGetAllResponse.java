package ge.freeuni.studentsplatformapp.dto;

import ge.freeuni.studentsplatformapp.model.School;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SchoolsGetAllResponse {
    private List<School> schools;
}
