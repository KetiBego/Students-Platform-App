package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.CreateFlashcardPackRequest;
import ge.freeuni.studentsplatformapp.dto.UpdateFlashcardPackRequest;
import ge.freeuni.studentsplatformapp.service.FlashcardPackService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/flashcard/packs")
@RequiredArgsConstructor
public class FlashcardPackController {

    private final FlashcardPackService flashcardPackService;

    @PostMapping()
    public ResponseEntity<Void> createFlashcardPack(@RequestBody @Valid CreateFlashcardPackRequest request) {
        flashcardPackService.createFlashcardPack(request);
        return new ResponseEntity<>(HttpStatus.CREATED);
    }

    @DeleteMapping()
    public ResponseEntity<Void> deleteFlashcardPack(@RequestBody @Valid Long flashcardPackId) {
        flashcardPackService.deleteFlashcardPack(flashcardPackId);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @PutMapping("/update")
    public ResponseEntity<Void> updateFlashcardPack(@RequestBody @Valid UpdateFlashcardPackRequest request) {
        flashcardPackService.updateFlashcardPack(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }

    @GetMapping("/subject/{subjectId}")
    public ResponseEntity<List<Long>> getFlashcardPacksBySubject(@PathVariable Long subjectId) {
        List<Long> flashcardPackIds = flashcardPackService.getSubjectFlashcardPacks(subjectId);
        return new ResponseEntity<>(flashcardPackIds, HttpStatus.OK);
    }
}
