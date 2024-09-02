package ge.freeuni.studentsplatformapp.dto;

import javax.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UpvoteRequest {
    @NotBlank
    private Long fileId;
}
