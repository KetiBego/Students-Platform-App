package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.FileUploadRequest;
import ge.freeuni.studentsplatformapp.dto.GetFileInfoResponse;
import ge.freeuni.studentsplatformapp.model.File;
import ge.freeuni.studentsplatformapp.model.FileType;
import ge.freeuni.studentsplatformapp.repository.FileRepository;
import ge.freeuni.studentsplatformapp.security.SignedInUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FileService {

    private final FileRepository fileRepository;
    private final UserService userService;
    private final SubjectsService subjectsService;
    private final UserUpvotesService userUpvotesService;
    private final SignedInUserService signedInUserService;

    public void uploadFile(FileUploadRequest request) throws IOException {
        File file = new File();
        file.setUserId(signedInUserService.getCurrentUserInfo().getId());
        file.setSubjectId(request.getSubjectId());
        file.setFileName(request.getFile().getOriginalFilename());
        file.setUpvoteCount(0L);
        file.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        String fileExtension = getFileExtension(file);
        try {
            file.setFileType(FileType.fromExtension(fileExtension));
        } catch (IllegalArgumentException e) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Invalid file extension: " + fileExtension);
        }
        file.setFileData(request.getFile().getBytes());

        fileRepository.save(file);
    }

    private String getFileExtension(File file) {
        String fileName = file.getFileName();
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0 && lastDotIndex < fileName.length() - 1) {
            return fileName.substring(lastDotIndex + 1).toLowerCase();
        }
        return "";
    }

    public Resource getResource(Long fileId) {
        File file = fileRepository.findById(fileId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "File not found"));
        return new ByteArrayResource(file.getFileData());
    }

    public String getFileName(Long fileId) {
        return fileRepository.findById(fileId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "File not found"))
                .getFileName();
    }

    public GetFileInfoResponse getFileInfo(Long fileId) {
        File file = fileRepository.findById(fileId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "File not found"));
        String username = userService.getUserById(file.getUserId()).getUsername();
        String subjectName = subjectsService.getSubjectNameById(file.getSubjectId());
        Boolean isUpvoted = userUpvotesService.isUpvoted(signedInUserService.getCurrentUserInfo().getId(), fileId);
        return new GetFileInfoResponse(file.getId(), username, subjectName, file.getFileName(), file.getUpvoteCount(), isUpvoted);
    }

    public List<GetFileInfoResponse> getUserFiles() {
        Long userId = signedInUserService.getCurrentUserInfo().getId();
        List<File> files = fileRepository.findByUserIdOrderByUpvoteCountDescCreatedAtDesc(userId);
        return files.stream()
                .map(file -> new GetFileInfoResponse(file.getId(), userService.getUserById(file.getUserId()).getUsername(),
                        subjectsService.getSubjectNameById(file.getId()), file.getFileName(), file.getUpvoteCount(),
                        userUpvotesService.isUpvoted(userId, file.getId())))
                .toList();
    }

    public List<GetFileInfoResponse> getSubjectFiles(Long subjectId) {
        List<File> files = fileRepository.findBySubjectIdOrderByUpvoteCountDescCreatedAtDesc(subjectId);
        Long userId = signedInUserService.getCurrentUserInfo().getId();
        return files.stream()
                .map(file -> new GetFileInfoResponse(file.getId(), userService.getUserById(file.getUserId()).getUsername(),
                        subjectsService.getSubjectNameById(file.getId()), file.getFileName(), file.getUpvoteCount(),
                        userUpvotesService.isUpvoted(userId, file.getId())))
                .toList();
    }

    public void deleteFile(Long fileId) {
        File file = fileRepository.findById(fileId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "File not found"));
        if (!file.getUserId().equals(signedInUserService.getCurrentUserInfo().getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You are not authorized to delete this file");
        }
        fileRepository.deleteById(fileId);
    }
}
