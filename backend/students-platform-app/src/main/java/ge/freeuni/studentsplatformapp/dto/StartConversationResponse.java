package ge.freeuni.studentsplatformapp.dto;

import ge.freeuni.studentsplatformapp.model.Message;
import javax.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class StartConversationResponse {
    @NotBlank
    private Long conversationId;

    @NotBlank
    private Boolean isNew;

    @NotBlank
    private List<Message> messages;
}
