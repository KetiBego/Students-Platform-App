package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserSignInResponse {
    @NotBlank
    private Long id;

    @NotBlank
    private String email;

    @NotBlank
    private String username;

    private String token;
}
