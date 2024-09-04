package ge.freeuni.studentsplatformapp.dto;

import ge.freeuni.studentsplatformapp.model.Flashcard;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GetFlashcardPackInfoResponse {
    @NotBlank
    private Long id;

    @NotBlank
    private String name;

    @NotBlank
    private String creatorUsername;

    @NotBlank
    private List<Flashcard> flashcards;

    @NotBlank
    private Boolean isMyPack;
}
