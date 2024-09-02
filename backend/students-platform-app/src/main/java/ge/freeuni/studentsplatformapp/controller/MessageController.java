package ge.freeuni.studentsplatformapp.controller;

import ge.freeuni.studentsplatformapp.dto.SendMessageRequest;
import ge.freeuni.studentsplatformapp.service.MessageService;
import javax.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/messages")
@RequiredArgsConstructor
public class MessageController {

    private final MessageService messageService;

    @PostMapping("/send")
    public ResponseEntity<Void> sendMessage(@RequestBody @Valid SendMessageRequest request) {
        messageService.sendMessage(request);
        return new ResponseEntity<>(HttpStatus.OK);
    }
}
