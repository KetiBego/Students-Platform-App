package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.service.FlashcardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/flashcards")
@RequiredArgsConstructor
public class FlashcardController {

    private final FlashcardService flashcardService;

    @DeleteMapping("/{flashcardId}")
    public ResponseEntity<Void> deleteFlashcard(@PathVariable Long flashcardId) {
        flashcardService.deleteFlashcard(flashcardId);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
