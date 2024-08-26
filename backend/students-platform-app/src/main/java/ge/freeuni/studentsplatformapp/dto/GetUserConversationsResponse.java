package ge.freeuni.studentsplatformapp.dto;

import ge.freeuni.studentsplatformapp.model.Conversation;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class GetUserConversationsResponse {
    @NotBlank
    List<Conversation> conversations;
}
