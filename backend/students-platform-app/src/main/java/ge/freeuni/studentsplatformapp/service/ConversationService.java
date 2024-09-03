package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.*;
import ge.freeuni.studentsplatformapp.model.Conversation;
import ge.freeuni.studentsplatformapp.repository.ConversationRepository;
import ge.freeuni.studentsplatformapp.repository.UserRepository;
import ge.freeuni.studentsplatformapp.security.SignedInUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ConversationService {

    private final ConversationRepository conversationRepository;
    private final UserRepository userRepository;

    private final MessageService messageService;
    private final SignedInUserService signedInUserService;
    private final UserService userService;

    public StartConversationResponse startConversation(StartConversationRequest request) {
        Long user1Id = signedInUserService.getCurrentUserInfo().getId();
        Long user2Id = request.getRecipientUserId();

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
            response.setMessages(messageService.getMessages(existingConversation.getId()));
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

    public GetUserConversationsResponse getUserConversations() {
        GetUserConversationsResponse response = new GetUserConversationsResponse();
        Long userId = signedInUserService.getCurrentUserInfo().getId();
        List<Conversation> conversations = conversationRepository.findByUser1IdOrUser2Id(userId, userId);

        List<UserConversationInfo> conversationInfos = new java.util.ArrayList<>(conversations.stream()
                .map(conversation -> {
                    UserConversationInfo info = new UserConversationInfo();
                    info.setConversationId(conversation.getId());
                    info.setUserId(conversation.getUser1Id().equals(userId) ? conversation.getUser2Id() : conversation.getUser1Id());
                    info.setUsername(conversation.getUser1Id().equals(userId) ? userService.getUserById(conversation.getUser2Id()).getUsername() :
                            userService.getUserById(conversation.getUser1Id()).getUsername());
                    info.setLastMessage(messageService.getLastMessage(conversation.getId()));
                    return info;
                })
                .toList());

        conversationInfos.sort((c1, c2) -> {
            if (c1.getLastMessage() == null && c2.getLastMessage() == null) {
                return 0;
            } else if (c1.getLastMessage() == null) {
                return 1;
            } else if (c2.getLastMessage() == null) {
                return -1;
            }
            return c2.getLastMessage().getCreatedAt().compareTo(c1.getLastMessage().getCreatedAt());
        });

        response.setConversationInfos(conversationInfos);
        return response;
    }

    public List<RecipientInfoResponse> getAllRecipients() {
        return userRepository.findAll()
                .stream().filter(user ->
                        !Objects.equals(user.getId(), signedInUserService.getCurrentUserInfo().getId()))
                .map(user ->
                        new RecipientInfoResponse(
                                user.getId(),
                                user.getUsername())
                ).collect(Collectors.toList());
    }
}
