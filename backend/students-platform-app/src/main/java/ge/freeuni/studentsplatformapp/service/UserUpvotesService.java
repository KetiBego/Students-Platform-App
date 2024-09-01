package ge.freeuni.studentsplatformapp.service;

import ge.freeuni.studentsplatformapp.dto.UpvoteRequest;
import ge.freeuni.studentsplatformapp.model.UserUpvote;
import ge.freeuni.studentsplatformapp.model.UserUpvoteId;
import ge.freeuni.studentsplatformapp.repository.FileRepository;
import ge.freeuni.studentsplatformapp.repository.UserUpvotesRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserUpvotesService {

    private final UserService userService;
    private final UserUpvotesRepository userUpvotesRepository;
    private final FileRepository fileRepository;

    public void addUserUpvote(UpvoteRequest request) {
        Long userId = userService.getCurrentUserInfo().getId();
        Long fileId = request.getFileId();
        UserUpvoteId userUpvoteId = new UserUpvoteId(userId, fileId);
        UserUpvote userUpvote = new UserUpvote(userUpvoteId);
        try {
            if (userUpvotesRepository.existsById(userUpvoteId)) {
                throw new RuntimeException("User already upvoted this file");
            }
            userUpvotesRepository.save(userUpvote);
            fileRepository.findById(fileId).ifPresent(file -> {
                file.setUpvoteCount(file.getUpvoteCount() + 1);
                fileRepository.save(file);
            });
        } catch (Exception e) {
            throw new RuntimeException("Failed to upvote file");
        }
    }

    public void removeUserUpvote(UpvoteRequest request) {
        Long userId = userService.getCurrentUserInfo().getId();
        Long fileId = request.getFileId();
        UserUpvoteId userUpvoteId = new UserUpvoteId(userId, fileId);
        try {
            if (!userUpvotesRepository.existsById(userUpvoteId)) {
                throw new RuntimeException("User did not upvote this file");
            }
            userUpvotesRepository.deleteById(userUpvoteId);
            fileRepository.findById(fileId).ifPresent(file -> {
                file.setUpvoteCount(file.getUpvoteCount() - 1);
                fileRepository.save(file);
            });
        } catch (Exception e) {
            throw new RuntimeException("Failed to remove upvote from file");
        }
    }

    public Boolean isUpvoted(Long userId, Long fileId) {
        UserUpvoteId userUpvoteId = new UserUpvoteId(userId, fileId);
        return userUpvotesRepository.findById(userUpvoteId).isPresent();
    }
}
