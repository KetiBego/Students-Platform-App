package ge.freeuni.studentsplatformapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.validation.constraints.NotBlank;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RecipientInfoResponse {
    @NotBlank
    private Long id;

    @NotBlank
    private String username;
}
