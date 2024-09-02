package ge.freeuni.studentsplatformapp.dto;

import ge.freeuni.studentsplatformapp.model.Conversation;
import javax.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class GetUserConversationsResponse {
    @NotBlank
    List<Conversation> conversations;
}
