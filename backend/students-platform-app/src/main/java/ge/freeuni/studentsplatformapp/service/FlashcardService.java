package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.model.Flashcard;
import ge.freeuni.studentsplatformapp.model.FlashcardPack;
import ge.freeuni.studentsplatformapp.repository.FlashcardPackRepository;
import ge.freeuni.studentsplatformapp.repository.FlashcardRepository;
import ge.freeuni.studentsplatformapp.security.SignedInUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

@Service
@RequiredArgsConstructor
public class FlashcardService {

    private final FlashcardRepository flashcardRepository;
    private final FlashcardPackRepository flashcardPackRepository;

    private final SignedInUserService signedInUserService;

    public void deleteFlashcard(Long flashcardId) {
        Flashcard flashcard = flashcardRepository.findById(flashcardId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Flashcard not found"));
        FlashcardPack flashcardPack = flashcardPackRepository.findById(flashcard.getPackId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Flashcard pack not found"));
        if (!flashcardPack.getUserId().equals(signedInUserService.getCurrentUserInfo().getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You are not allowed to delete this flashcard");
        }
        flashcardRepository.deleteById(flashcardId);
    }
}
