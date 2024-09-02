package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.AddUserSubjectRequest;
import ge.freeuni.studentsplatformapp.dto.GetUserSubjectsRequest;
import ge.freeuni.studentsplatformapp.dto.GetUserSubjectsResponse;
import ge.freeuni.studentsplatformapp.service.UserSubjectsService;
import javax.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user/subjects")
@RequiredArgsConstructor
public class UserSubjectsController {

    private final UserSubjectsService userSubjectService;

    @PostMapping("/add")
    public ResponseEntity<Void> addUserSubject(@RequestBody @Valid AddUserSubjectRequest request) {
        userSubjectService.addUserSubject(request);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @GetMapping
    public ResponseEntity<GetUserSubjectsResponse> getUserSubjects() {
        GetUserSubjectsResponse response = userSubjectService.getUserSubjects();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @DeleteMapping
    public ResponseEntity<Void> deleteUserSubject(@RequestBody @Valid AddUserSubjectRequest request) {
        userSubjectService.deleteUserSubject(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
