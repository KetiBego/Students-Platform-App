package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UserSignInResponse {
    @NotBlank
    private Long id;

    @NotBlank
    private String email;

    @NotBlank
    private String username;
}
