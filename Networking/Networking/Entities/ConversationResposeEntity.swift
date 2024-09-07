//
//  ConversationResposeEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//


public struct ConversationResponseEntity {
    public var conversationInfos: [ConversationEntity]
    
    public init(conversationInfos: [ConversationEntity]) {
        self.conversationInfos = conversationInfos
    }
    
    public init(with model: ConversationResponse) {
        self.conversationInfos = model.conversationInfos.map { ConversationEntity(with: $0) }
    }
}


public struct ConversationEntity {
    public var conversationId: Int?
    public var userId: Int?
    public var username: String?
    public var lastMessage: MessageEntity?
    
    public init(
        conversationId: Int?,
        userId: Int?,
        username: String?,
        lastMessage: MessageEntity?
    ) {
        self.conversationId = conversationId
        self.userId = userId
        self.username = username
        self.lastMessage = lastMessage
    }
    
    public init(with model: ConversationInfo) {
        self.conversationId = model.conversationId
        self.userId = model.userId
        self.username = model.username
        self.lastMessage = MessageEntity(with: model.lastMessage)
    }
}

public struct MessageEntity {
    public var id: Int?
    public var senderId: Int?
    public var conversationId: Int?
    public var message: String?
    public var createdAt: String?
    
    public init(
        id: Int?,
        senderId: Int?,
        conversationId: Int?,
        message: String?,
        createdAt: String?
    ) {
        self.id = id
        self.senderId = senderId
        self.conversationId = conversationId
        self.message = message
        self.createdAt = createdAt
    }
    
    public init(with model: LastMessage?) {
        self.id = model?.id
        self.senderId = model?.senderId
        self.conversationId = model?.conversationId
        self.message = model?.message
        self.createdAt = model?.createdAt
    }
}
