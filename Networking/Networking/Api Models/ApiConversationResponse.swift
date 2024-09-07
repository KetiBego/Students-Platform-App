//
//  ApiConversationResponse.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import Foundation

public struct ConversationResponse: Decodable {
    let conversationInfos: [ConversationInfo]
}

public struct ConversationInfo: Decodable {
    let conversationId: Int?
    let userId: Int?
    let username: String?
    let lastMessage: LastMessage?
}

public struct LastMessage: Decodable {
    let id: Int?
    let senderId: Int?
    let conversationId: Int?
    let message: String?
    let createdAt: String?
}
