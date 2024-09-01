package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpvoteRequest {
    @NotBlank
    private Long fileId;
}
