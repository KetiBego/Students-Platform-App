package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.GetUserConversationsResponse;
import ge.freeuni.studentsplatformapp.dto.StartConversationRequest;
import ge.freeuni.studentsplatformapp.dto.StartConversationResponse;
import ge.freeuni.studentsplatformapp.model.Conversation;
import ge.freeuni.studentsplatformapp.repository.ConversationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ConversationService {

    private final ConversationRepository conversationRepository;

    public StartConversationResponse startConversation(StartConversationRequest request) {
        Long user1Id = request.getUser1Id();
        Long user2Id = request.getUser2Id();

        StartConversationResponse response = new StartConversationResponse();

        if (user2Id < user1Id) {
            Long temp = user1Id;
            user1Id = user2Id;
            user2Id = temp;
        }

        Conversation existingConversation = conversationRepository.findByUser1IdAndUser2Id(user1Id, user2Id);

        if (existingConversation != null) {
            response.setConversationId(existingConversation.getId());
            response.setIsNew(false);
        } else {
            Conversation newConversation = new Conversation();
            newConversation.setUser1Id(user1Id);
            newConversation.setUser2Id(user2Id);
            Conversation savedConversation = conversationRepository.save(newConversation);
            response.setConversationId(savedConversation.getId());
            response.setIsNew(true);
        }

        return response;
    }

    public GetUserConversationsResponse getUserConversations(Long userId) {
        GetUserConversationsResponse response = new GetUserConversationsResponse();
        response.setConversations(conversationRepository.findByUser1IdOrUser2Id(userId, userId));
        return response;
    }
}
