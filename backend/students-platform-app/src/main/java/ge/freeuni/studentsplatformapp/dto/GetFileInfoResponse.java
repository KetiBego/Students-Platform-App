package ge.freeuni.studentsplatformapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GetFileInfoResponse {
    private Long userId;
    private Long subjectId;
    private String fileName;
    private Long upvoteCount;
}
