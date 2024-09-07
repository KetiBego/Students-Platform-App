//
//  ApiConversationStart.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

public struct ApiMessage: Decodable {
    let id: Int
    let senderId: Int
    let conversationId: Int
    let message: String
    let createdAt: String
}

public struct ApiConversationStartResponse: Decodable {
    let conversationId: Int
    let isNew: Bool
    let messages: [ApiMessage]?
}
