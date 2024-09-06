package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.*;
import ge.freeuni.studentsplatformapp.service.ConversationService;
import javax.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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

    @GetMapping("/user")
    public ResponseEntity<GetUserConversationsResponse> getUserConversations() {
        GetUserConversationsResponse response = conversationService.getUserConversations();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @GetMapping("/recipients")
    public ResponseEntity<List<RecipientInfoResponse>> getAllRecipients() {
        List<RecipientInfoResponse> response = conversationService.getAllRecipients();
        return new ResponseEntity<>(response, HttpStatus.OK);
    }
}
