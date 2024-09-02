package ge.freeuni.studentsplatformapp.dto;

import javax.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class StartConversationRequest {
    @NotBlank
    private Long user1Id;

    @NotBlank
    private Long user2Id;
}
