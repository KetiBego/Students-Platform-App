package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AddUserSubjectRequest {
    @NotBlank
    private Long subjectId;
}
