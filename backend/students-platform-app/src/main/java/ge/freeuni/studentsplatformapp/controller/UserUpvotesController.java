package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.AddUserUpvoteRequest;
import ge.freeuni.studentsplatformapp.dto.RemoveUserUpvoteRequest;
import ge.freeuni.studentsplatformapp.service.UserUpvotesService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/files/upvotes")
@RequiredArgsConstructor
public class UserUpvotesController {

    private final UserUpvotesService userUpvotesService;

    @PostMapping("/add")
    public ResponseEntity<Void> addUserUpvote(@RequestBody @Valid AddUserUpvoteRequest request) {
        try {
            userUpvotesService.addUserUpvote(request);
            return new ResponseEntity<>(HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/remove")
    public ResponseEntity<Void> removeUserUpvote(@RequestBody @Valid RemoveUserUpvoteRequest request) {
        try {
            userUpvotesService.removeUserUpvote(request);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
