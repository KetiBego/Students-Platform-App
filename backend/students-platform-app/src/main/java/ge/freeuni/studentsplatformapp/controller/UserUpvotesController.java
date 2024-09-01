package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.UpvoteRequest;
import ge.freeuni.studentsplatformapp.service.UserUpvotesService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/files/upvotes")
@RequiredArgsConstructor
public class UserUpvotesController {

    private final UserUpvotesService userUpvotesService;

    @PostMapping("/add")
    public ResponseEntity<Void> addUserUpvote(@RequestBody @Valid UpvoteRequest request) {
        try {
            userUpvotesService.addUserUpvote(request);
            return new ResponseEntity<>(HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping
    public ResponseEntity<Void> removeUserUpvote(@RequestBody @Valid UpvoteRequest request) {
        try {
            userUpvotesService.removeUserUpvote(request);
            return new ResponseEntity<>(HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
