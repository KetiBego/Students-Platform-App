package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.SchoolsGetAllResponse;
import ge.freeuni.studentsplatformapp.service.SchoolsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/schools")
@RequiredArgsConstructor
public class SchoolsController {

    private final SchoolsService schoolsService;

    @GetMapping("/all")
    public ResponseEntity<SchoolsGetAllResponse> getSchools() {
        SchoolsGetAllResponse response = schoolsService.getSchools();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
