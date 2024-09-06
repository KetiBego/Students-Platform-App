package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.CreateFlashcardPackRequest;
import ge.freeuni.studentsplatformapp.dto.GetFlashcardPackInfoResponse;
import ge.freeuni.studentsplatformapp.dto.UpdateFlashcardPackRequest;
import ge.freeuni.studentsplatformapp.model.Flashcard;
import ge.freeuni.studentsplatformapp.model.FlashcardPack;
import ge.freeuni.studentsplatformapp.repository.FlashcardPackRepository;
import ge.freeuni.studentsplatformapp.repository.FlashcardRepository;
import ge.freeuni.studentsplatformapp.security.SignedInUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.sql.Timestamp;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FlashcardPackService {

    private final FlashcardPackRepository flashcardPackRepository;
    private final FlashcardRepository flashcardRepository;
    private final SignedInUserService signedInUserService;
    private final UserService userService;

    public void createFlashcardPack(CreateFlashcardPackRequest request) {
        FlashcardPack flashcardPack = new FlashcardPack();
        flashcardPack.setName(request.getName());
        flashcardPack.setSubjectId(request.getSubjectId());
        flashcardPack.setUserId(signedInUserService.getCurrentUserInfo().getId());
        flashcardPack.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        Long flashcardPackId = flashcardPackRepository.save(flashcardPack).getId();
        request.getFlashcards().forEach(flashcard -> {
            Flashcard newFlashcard = new Flashcard();
            newFlashcard.setPackId(flashcardPackId);
            newFlashcard.setQuestion(flashcard.getQuestion());
            newFlashcard.setAnswer(flashcard.getAnswer());
            flashcardRepository.save(newFlashcard);
        });
    }

    public void deleteFlashcardPack(Long flashcardPackId) {
        FlashcardPack flashcardPack = flashcardPackRepository.findById(flashcardPackId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Flashcard pack not found"));
        if (!flashcardPack.getUserId().equals(signedInUserService.getCurrentUserInfo().getId())) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You are not allowed to delete this flashcard pack");
        }
        flashcardPackRepository.deleteById(flashcardPackId);
    }

    public void updateFlashcardPack(UpdateFlashcardPackRequest request) {
        try {
            FlashcardPack flashcardPack =
                    flashcardPackRepository.findById(request.getFlashcardPackId()).orElseThrow();
            if (!flashcardPack.getUserId().equals(signedInUserService.getCurrentUserInfo().getId())) {
                throw new ResponseStatusException(HttpStatus.FORBIDDEN, "You are not allowed to update this flashcard pack");
            }
            request.getFlashcards().forEach(flashcard -> {
                Flashcard newFlashcard = new Flashcard();
                newFlashcard.setPackId(flashcardPack.getId());
                newFlashcard.setQuestion(flashcard.getQuestion());
                newFlashcard.setAnswer(flashcard.getAnswer());
                flashcardRepository.save(newFlashcard);
            });
            flashcardPack.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            flashcardPackRepository.save(flashcardPack);
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Flashcard pack not found");
        }
    }

    public List<GetFlashcardPackInfoResponse> getSubjectFlashcardPacks(Long subjectId) {
        List<FlashcardPack> flashcardPacks = flashcardPackRepository.findBySubjectIdOrderByCreatedAtDesc(subjectId);
        return flashcardPacks.stream()
                .map(flashcardPack -> {
                    GetFlashcardPackInfoResponse response = new GetFlashcardPackInfoResponse();
                    response.setId(flashcardPack.getId());
                    response.setName(flashcardPack.getName());
                    response.setCreatorUsername(userService.getUserById(flashcardPack.getUserId()).getUsername());
                    response.setFlashcards(flashcardRepository.findByPackId(flashcardPack.getId()));
                    response.setIsMyPack(flashcardPack.getUserId().equals(signedInUserService.getCurrentUserInfo().getId()));
                    return response;
                })
                .toList();
    }
}
