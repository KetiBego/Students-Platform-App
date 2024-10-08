package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.AddUserSubjectRequest;
import ge.freeuni.studentsplatformapp.dto.GetUserSubjectsResponse;
import ge.freeuni.studentsplatformapp.model.UserSubject;
import ge.freeuni.studentsplatformapp.model.UserSubjectId;
import ge.freeuni.studentsplatformapp.repository.SubjectsRepository;
import ge.freeuni.studentsplatformapp.repository.UserSubjectsRepository;
import ge.freeuni.studentsplatformapp.security.SignedInUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserSubjectsService {

    private final UserSubjectsRepository userSubjectRepository;
    private final SubjectsRepository subjectsRepository;
    private final SignedInUserService signedInUserService;

    public void addUserSubject(AddUserSubjectRequest request) {
        Long userId = signedInUserService.getCurrentUserInfo().getId();
        Long subjectId = request.getSubjectId();
        UserSubjectId userSubjectId = new UserSubjectId(userId, subjectId);
        UserSubject userSubject = new UserSubject(userSubjectId);
        userSubjectRepository.save(userSubject);
    }

    public GetUserSubjectsResponse getUserSubjects() {
        Long userId = signedInUserService.getCurrentUserInfo().getId();
        GetUserSubjectsResponse response = new GetUserSubjectsResponse();
        List<UserSubject> userSubjects = userSubjectRepository.findByIdUserId(userId);
        response.setSubjects(
                subjectsRepository.findAllById(
                        userSubjects.stream()
                                .map(UserSubject::getId)
                                .map(UserSubjectId::getSubjectId)
                                .toList()));
        return response;
    }

    public void deleteUserSubject(AddUserSubjectRequest request) {
        Long userId = signedInUserService.getCurrentUserInfo().getId();
        Long subjectId = request.getSubjectId();
        UserSubjectId userSubjectId = new UserSubjectId(userId, subjectId);
        userSubjectRepository.deleteById(userSubjectId);
    }
}
