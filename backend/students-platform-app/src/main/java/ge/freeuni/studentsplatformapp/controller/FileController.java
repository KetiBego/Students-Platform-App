package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.FileUploadRequest;
import ge.freeuni.studentsplatformapp.dto.GetFileInfoResponse;
import ge.freeuni.studentsplatformapp.service.FileService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/files")
@RequiredArgsConstructor
public class FileController {

    private final FileService fileService;

    @PostMapping(value = "/upload", consumes = "multipart/form-data")
    public ResponseEntity<Void> uploadFile(@RequestParam Long subjectId, @RequestParam MultipartFile file) {
        FileUploadRequest request = new FileUploadRequest(subjectId, file);
        try {
            fileService.uploadFile(request);
            return new ResponseEntity<>(HttpStatus.CREATED);
        } catch (IOException e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/download/{fileId}")
    public ResponseEntity<Resource> downloadFile(@PathVariable Long fileId) {
        try {
            Resource resource = fileService.getResource(fileId);
            String fileName = fileService.getFileName(fileId);

            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_OCTET_STREAM)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                    .body(resource);
        } catch (ResponseStatusException e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/fileInfo/{fileId}")
    public ResponseEntity<GetFileInfoResponse> getFileInfo(@PathVariable Long fileId) {
        GetFileInfoResponse response = fileService.getFileInfo(fileId);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/user")
    public ResponseEntity<List<GetFileInfoResponse>> getUserFiles() {
        List<GetFileInfoResponse> fileInfoResponses = fileService.getUserFiles();
        return ResponseEntity.ok(fileInfoResponses);
    }

    @GetMapping("/subject/{subjectId}")
    public ResponseEntity<List<GetFileInfoResponse>> getSubjectFiles(@PathVariable Long subjectId) {
        List<GetFileInfoResponse> fileIds = fileService.getSubjectFiles(subjectId);
        return ResponseEntity.ok(fileIds);
    }

    @DeleteMapping("/{fileId}")
    public ResponseEntity<Void> deleteFile(@PathVariable Long fileId) {
        fileService.deleteFile(fileId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
