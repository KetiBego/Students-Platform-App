package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class StartConversationResponse {
    @NotBlank
    private Long conversationId;

    @NotBlank
    private Boolean isNew;
}
