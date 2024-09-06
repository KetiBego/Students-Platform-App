package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.*;
import ge.freeuni.studentsplatformapp.model.User;
import ge.freeuni.studentsplatformapp.repository.UserRepository;
import ge.freeuni.studentsplatformapp.security.JwtUtil;
import ge.freeuni.studentsplatformapp.security.SignedInUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final AuthenticationManager authenticationManager;

    private static final String ACCEPTABLE_SUFFIX = "freeuni.edu.ge";
    private final SignedInUserService signedInUserService;

    public void createUser(UserCreateRequest request) {
        String email = request.getEmail();
        String username = request.getUsername();
        String password = request.getPassword();
        Integer schoolId = request.getSchoolId();

        String[] emailParts = email.split("@");
        if (emailParts.length != 2 || !emailParts[1].equals(ACCEPTABLE_SUFFIX)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Email must be of the form <username>@" + ACCEPTABLE_SUFFIX);
        }

        if (userRepository.findByEmail(email) != null) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "User with email " + email + " already exists");
        }

        User user = User.builder()
                .email(email)
                .username(username)
                .hashedPassword(passwordEncoder.encode(password))
                .schoolId(schoolId)
                .build();

        userRepository.save(user);
    }

    public UserSignInResponse signInUser(UserSignInRequest request) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword())
            );

            String token = jwtUtil.generateToken(authentication.getName());

            return UserSignInResponse.builder()
                    .id(userRepository.findByEmail(authentication.getName()).getId())
                    .email(request.getEmail())
                    .username(userRepository.findByEmail(authentication.getName()).getUsername())
                    .token(token)
                    .build();
        } catch (AuthenticationException e) {
            System.out.println(e.getMessage());
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
        }
    }

    public User getUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));
    }
}