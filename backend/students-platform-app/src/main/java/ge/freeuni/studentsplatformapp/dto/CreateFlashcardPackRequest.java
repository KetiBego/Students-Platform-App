package ge.freeuni.studentsplatformapp.dto;

import javax.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class CreateFlashcardPackRequest {
    @NotBlank
    private String name;

    @NotBlank
    private Long subjectId;

    @NotBlank
    private List<CreateFlashcardRequest> flashcards;

}
