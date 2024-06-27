package ge.freeuni.studentsplatformapp.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FileUploadRequest {
    private Long userId;
    private Long subjectId;
    private MultipartFile file;
}
