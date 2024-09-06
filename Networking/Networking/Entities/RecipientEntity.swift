//
//  RecipientEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

public struct RecipientEntity {
    public let id: Int
    public let username: String
    
    public init(id: Int, username: String) {
        self.id = id
        self.username = username
    }
    
    public init(with model: ApiRecipient) {
        self.id = model.id
        self.username = model.username
    }
}
