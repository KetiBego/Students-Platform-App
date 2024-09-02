package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.GetUserConversationsResponse;
import ge.freeuni.studentsplatformapp.dto.StartConversationRequest;
import ge.freeuni.studentsplatformapp.dto.StartConversationResponse;
import ge.freeuni.studentsplatformapp.service.ConversationService;
import javax.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/conversations")
@RequiredArgsConstructor
public class ConversationController {

    private final ConversationService conversationService;

    @PostMapping("/start")
    public ResponseEntity<StartConversationResponse> startConversation(@RequestBody @Valid StartConversationRequest request) {
        StartConversationResponse response = conversationService.startConversation(request);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<GetUserConversationsResponse> getUserConversations(@PathVariable Long userId) {
        GetUserConversationsResponse response = conversationService.getUserConversations(userId);
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
