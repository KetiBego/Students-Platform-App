package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.SubjectsGetAllResponse;
import ge.freeuni.studentsplatformapp.model.Subject;
import ge.freeuni.studentsplatformapp.repository.SubjectsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class SubjectsService {

    private final SubjectsRepository subjectsRepository;

    public SubjectsGetAllResponse getSubjects() {
        SubjectsGetAllResponse response = new SubjectsGetAllResponse();
        response.setSubjects(subjectsRepository.findAll());
        return response;
    }

    public String getSubjectNameById(Long subjectId) {
        Optional<Subject> subjectOptional = subjectsRepository.findById(subjectId);
        return subjectOptional.map(Subject::getSubjectName).orElse(null);
    }
}
