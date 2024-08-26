package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class AddUserUpvoteRequest {
    @NotBlank
    private Long userId;

    @NotBlank
    private Long fileId;
}
