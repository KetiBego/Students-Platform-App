package ge.freeuni.studentsplatformapp.model;

import javax.persistence.*;
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

    @Column(name = "sender_id")
    private Long senderId;

    @Column(name = "conversation_id")
    private Long conversationId;

    @Column(nullable = false)
    private String message;

    @Column(name = "created_at", nullable = false)
    private Timestamp createdAt;
}
