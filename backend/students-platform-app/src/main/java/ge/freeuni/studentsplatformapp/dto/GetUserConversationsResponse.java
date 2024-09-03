package ge.freeuni.studentsplatformapp.dto;

import javax.validation.constraints.NotBlank;
import lombok.Data;

import java.util.List;

@Data
public class GetUserConversationsResponse {
    @NotBlank
    List<UserConversationInfo> conversationInfos;
}
