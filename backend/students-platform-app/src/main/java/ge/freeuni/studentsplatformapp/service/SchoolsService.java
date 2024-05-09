package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.SchoolsGetAllResponse;
import ge.freeuni.studentsplatformapp.repository.SchoolsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SchoolsService {

    private final SchoolsRepository schoolsRepository;

    public SchoolsGetAllResponse getSchools() {
        SchoolsGetAllResponse response = new SchoolsGetAllResponse();
        response.setSchools(schoolsRepository.findAll());
        return response;
    }
}
