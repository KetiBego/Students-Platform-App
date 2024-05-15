package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.SubjectsGetAllResponse;
import ge.freeuni.studentsplatformapp.service.SubjectsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/subjects")
@RequiredArgsConstructor
public class SubjectsController {

    private final SubjectsService subjectsService;

    @GetMapping("/all")
    public ResponseEntity<SubjectsGetAllResponse> getSubjects() {
        SubjectsGetAllResponse response = subjectsService.getSubjects();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
