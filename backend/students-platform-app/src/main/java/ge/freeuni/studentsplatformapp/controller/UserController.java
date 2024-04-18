package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @PostMapping("/create")
    public String createUser(String email, String password) {
        userService.createUser(email, password);
        return "User created";
    }

    @PostMapping("/signIn")
    public String signInUser(String email, String password) {
        userService.signInUser(email, password);
        return "User signed in";
    }
}
