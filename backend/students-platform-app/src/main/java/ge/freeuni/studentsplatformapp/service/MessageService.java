package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.SendMessageRequest;
import ge.freeuni.studentsplatformapp.model.Message;
import ge.freeuni.studentsplatformapp.repository.MessageRepository;
import ge.freeuni.studentsplatformapp.security.SignedInUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.sql.Timestamp;
import java.util.List;

@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageRepository messageRepository;
    private final SignedInUserService signedInUserService;

    public void sendMessage(SendMessageRequest request) {
        Message message = new Message();
        message.setSenderId(signedInUserService.getCurrentUserInfo().getId());
        message.setConversationId(request.getConversationId());
        message.setMessage(request.getMessage());
        message.setCreatedAt(new Timestamp(System.currentTimeMillis()));

        messageRepository.save(message);
    }

    public List<Message> getMessages(Long conversationId) {
        return messageRepository.findByConversationIdOrderByCreatedAtDesc(conversationId);
    }

    public Message getLastMessage(Long conversationId) {
        return messageRepository.findFirstByConversationIdOrderByCreatedAtDesc(conversationId);
    }
}
