//
//  ApiFlashCards.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import Foundation

// Represents a flashcard
public struct ApiFlashcard: Codable {
    let id: Int
    let packId: Int
    let question: String
    let answer: String
}

// Represents a flashcard pack
public struct ApiFlashcardPack: Codable {
    let id: Int
    let name: String
    let creatorUsername: String
    let flashcards: [ApiFlashcard]
    let isMyPack: Bool
}

// Represents an array of flashcard packs response
//public typealias FlashcardPacksResponse = [FlashcardPack]
