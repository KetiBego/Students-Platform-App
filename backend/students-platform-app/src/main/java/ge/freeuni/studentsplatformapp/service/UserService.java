package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.UserCreateRequest;
import ge.freeuni.studentsplatformapp.dto.UserSignInRequest;
import ge.freeuni.studentsplatformapp.dto.UserSignInResponse;
import ge.freeuni.studentsplatformapp.model.User;
import ge.freeuni.studentsplatformapp.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    private static final String acceptableSuffix = "freeuni.edu.ge";

    public void createUser(UserCreateRequest request) {
        String email = request.getEmail();
        String username = request.getUsername();
        String password = request.getPassword();
        Integer schoolId = request.getSchoolId();
        //cut at @
        String[] emailParts = email.split("@");
        if (emailParts.length != 2 || !emailParts[1].equals(acceptableSuffix)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST,
                    "Email must be of the form <username>" + acceptableSuffix);
        }

        if (userRepository.findByEmail(email) != null) {
            throw new ResponseStatusException(HttpStatus.CONFLICT,
                    "User with email " + email + " already exists");
        } else {
            userRepository.save(User
                    .builder()
                    .email(email)
                    .username(username)
                    .hashedPassword(hashPassword(password))
                    .schoolId(schoolId)
                    .build());
        }
    }

    public UserSignInResponse signInUser(UserSignInRequest request) {
        String email = request.getEmail();
        String password = request.getPassword();

        User user = userRepository.findByEmail(email);
        if (user == null) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND,
                    "User with email " + email + " not found");
        } else {
            if (!user.getHashedPassword().equals(hashPassword(password))) {
                throw new ResponseStatusException(HttpStatus.UNAUTHORIZED,
                        "Incorrect password");
            }
        }
        UserSignInResponse response = new UserSignInResponse();
        response.setId(user.getId());
        response.setEmail(user.getEmail());
        response.setUsername(user.getUsername());
        return response;
    }

    private String hashPassword(String password) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(password.getBytes());

            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not found", e);
        }
    }
}
