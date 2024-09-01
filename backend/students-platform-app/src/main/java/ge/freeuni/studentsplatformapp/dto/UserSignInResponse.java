package ge.freeuni.studentsplatformapp.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserSignInResponse {
    @NotBlank
    private Long id;

    @NotBlank
    private String email;

    @NotBlank
    private String username;

    private String token;
}
