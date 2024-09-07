//
//  ConversationStartEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

public struct PostMessageEntity {
    public let id: Int
    public let senderId: Int
    public let conversationId: Int
    public let message: String
    public let createdAt: String
    
    public init(id: Int, senderId: Int, conversationId: Int, message: String, createdAt: String) {
        self.id = id
        self.senderId = senderId
        self.conversationId = conversationId
        self.message = message
        self.createdAt = createdAt
    }
    
    public init(with model: ApiMessage) {
        self.id = model.id
        self.senderId = model.senderId
        self.conversationId = model.conversationId
        self.message = model.message
        self.createdAt = model.createdAt
    }
}

public struct ConversationStartResponseEntity {
    public let conversationId: Int
    public let isNew: Bool
    public let messages: [PostMessageEntity]
    
    public init(conversationId: Int, isNew: Bool, messages: [PostMessageEntity]) {
        self.conversationId = conversationId
        self.isNew = isNew
        self.messages = messages
    }
    
    public init(with model: ApiConversationStartResponse) {
        self.conversationId = model.conversationId
        self.isNew = model.isNew
        self.messages = model.messages?.map { PostMessageEntity(with: $0) } ?? []
    }
}
