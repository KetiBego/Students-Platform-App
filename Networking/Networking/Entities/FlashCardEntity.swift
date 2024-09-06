//
//  FlashCardEntitii.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

public struct FlashcardEntity {
    public init(
        id: Int,
        packId: Int,
        question: String,
        answer: String
    ) {
        self.id = id
        self.packId = packId
        self.question = question
        self.answer = answer
    }
    
    public var id: Int
    public var packId: Int
    public var question: String
    public var answer: String
    
    
    public init(with model: ApiFlashcard) {
        self.id = model.id
        self.packId = model.packId
        self.question = model.question
        self.answer = model.answer
    }
    
}


public struct FlashcardPack {
    public init(
        id: Int,
        name: String,
        creatorUsername: String,
        flashcards: [FlashcardEntity],
        isMyPack: Bool
    ) {
        self.id = id
        self.name = name
        self.creatorUsername = creatorUsername
        self.flashcards = flashcards
        self.isMyPack = isMyPack
    }
    
    public var id: Int
    public var name: String
    public var creatorUsername: String
    public var flashcards: [FlashcardEntity]
    private var isMyPack: Bool
    
    
    public init(with model: ApiFlashcardPack) {
        self.id = model.id
        self.name = model.name
        self.creatorUsername = model.creatorUsername
        self.flashcards = model.flashcards.map { FlashcardEntity(with: $0) }
        self.isMyPack = model.isMyPack
    }
    
}
