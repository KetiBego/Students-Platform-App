package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.UserCreateRequest;
import ge.freeuni.studentsplatformapp.dto.UserSignInRequest;
import ge.freeuni.studentsplatformapp.dto.UserSignInResponse;
import ge.freeuni.studentsplatformapp.security.CustomUserDetails;
import ge.freeuni.studentsplatformapp.security.SignedInUserService;
import ge.freeuni.studentsplatformapp.service.UserService;
import javax.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final SignedInUserService signedInUserService;

    @PostMapping
    public ResponseEntity<Void> createUser(@RequestBody @Valid UserCreateRequest request) {
        userService.createUser(request);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @PostMapping("/signIn")
    public ResponseEntity<UserSignInResponse> signInUser(@RequestBody @Valid UserSignInRequest request) {
        UserSignInResponse response = userService.signInUser(request);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/me")
    public ResponseEntity<CustomUserDetails> getCurrentUser() {
        CustomUserDetails userDetails = signedInUserService.getCurrentUserInfo();
        return new ResponseEntity<>(userDetails, HttpStatus.OK);
    }
}