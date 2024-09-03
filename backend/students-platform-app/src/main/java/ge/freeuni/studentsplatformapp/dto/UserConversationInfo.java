package ge.freeuni.studentsplatformapp.dto;

import ge.freeuni.studentsplatformapp.model.Message;
import lombok.Data;

@Data
public class UserConversationInfo {
    Long conversationId;
    Long userId;
    String username;
    Message lastMessage;
}
