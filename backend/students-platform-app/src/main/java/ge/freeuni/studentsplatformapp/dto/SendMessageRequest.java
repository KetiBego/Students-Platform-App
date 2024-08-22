package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class SendMessageRequest {
    @NotBlank
    private Long senderId;

    @NotBlank
    private Long conversationId;

    @NotBlank
    private String message;
}
