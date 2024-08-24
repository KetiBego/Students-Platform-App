package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.CreateFlashcardPackRequest;
import ge.freeuni.studentsplatformapp.dto.UpdateFlashcardPackRequest;
import ge.freeuni.studentsplatformapp.model.Flashcard;
import ge.freeuni.studentsplatformapp.model.FlashcardPack;
import ge.freeuni.studentsplatformapp.repository.FlashcardPackRepository;
import ge.freeuni.studentsplatformapp.repository.FlashcardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;

@Service
@RequiredArgsConstructor
public class FlashcardPackService {

    private final FlashcardPackRepository flashcardPackRepository;
    private final FlashcardRepository flashcardRepository;

    public void createFlashcardPack(CreateFlashcardPackRequest request) {
        FlashcardPack flashcardPack = new FlashcardPack();
        flashcardPack.setName(request.getName());
        flashcardPack.setSubjectId(request.getSubjectId());
        flashcardPack.setUserId(request.getUserId());
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
        flashcardPackRepository.deleteById(flashcardPackId);
    }

    public void updateFlashcardPack(UpdateFlashcardPackRequest request) {
        try {
            FlashcardPack flashcardPack =
                    flashcardPackRepository.findById(request.getFlashcardPackId()).orElseThrow();
            request.getFlashcards().forEach(flashcard -> {
                Flashcard newFlashcard = new Flashcard();
                newFlashcard.setPackId(flashcardPack.getId());
                newFlashcard.setQuestion(flashcard.getQuestion());
                newFlashcard.setAnswer(flashcard.getAnswer());
                flashcardRepository.save(newFlashcard);
            });
        } catch (Exception e) {
            throw new RuntimeException("Flashcard pack not found");
        }
    }

    public List<Long> getSubjectFlashcardPacks(Long subjectId) {
        List<FlashcardPack> flashcardPacks = flashcardPackRepository.findBySubjectIdOrderByCreatedAtDesc(subjectId);
        return flashcardPacks.stream()
                .map(FlashcardPack::getId)
                .toList();
    }
}
