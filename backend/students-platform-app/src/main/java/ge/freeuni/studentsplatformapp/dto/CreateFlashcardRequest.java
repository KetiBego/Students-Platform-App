package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class CreateFlashcardRequest {
    @NotBlank
    private String question;

    @NotBlank
    private String answer;
}
