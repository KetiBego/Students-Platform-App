package ge.freeuni.studentsplatformapp.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.sql.Timestamp;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity(name = "messages")
public class Message {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "from_id")
    private Long fromId;

    @Column(name = "conversation_id")
    private Long conversationId;

    @Column(nullable = false)
    private String message;

    @Column(name = "created_at", nullable = false)
    private Timestamp createdAt;
}
