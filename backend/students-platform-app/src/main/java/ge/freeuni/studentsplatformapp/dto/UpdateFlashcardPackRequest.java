package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class UpdateFlashcardPackRequest {

    @NotBlank
    private Long flashcardPackId;

    @NotBlank
    private List<CreateFlashcardRequest> flashcards;
}
