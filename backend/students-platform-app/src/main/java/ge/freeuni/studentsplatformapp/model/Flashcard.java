package ge.freeuni.studentsplatformapp.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "FLASHCARDS")
public class Flashcard {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "pack_id", nullable = false)
    private Long packId;

    @Column(nullable = false)
    private String question;

    @Column(nullable = false)
    private String answer;
}
