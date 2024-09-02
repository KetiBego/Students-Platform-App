package ge.freeuni.studentsplatformapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GetFileInfoResponse {
    private Long id;
    private String username;
    private String subjectName;
    private String fileName;
    private Long upvoteCount;
    private Boolean isUpvoted;
}
