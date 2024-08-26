package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.repository.FlashcardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class FlashcardService {

    private final FlashcardRepository flashcardRepository;

    public void deleteFlashcard(Long flashcardId) {
        flashcardRepository.deleteById(flashcardId);
    }
}
