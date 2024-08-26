package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class CreateFlashcardPackRequest {
    @NotBlank
    private String name;

    @NotBlank
    private Long subjectId;

    @NotBlank
    private Long userId;

    @NotBlank
    private List<CreateFlashcardRequest> flashcards;

}
