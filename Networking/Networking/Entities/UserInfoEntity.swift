//
//  UserInfoEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 07.09.24.
//

public struct UserInfoEntity {
    public init(id: Int?, displayName: String?, username: String?) {
        self.id = id
        self.displayName = displayName
        self.username = username
    }
    
    public var id: Int?
    public var displayName: String?
    public var username: String?
    
    // Initializer that takes a Subject model
    public init(with model: ApiUserInfo) {
        self.id = model.id
        self.displayName = model.displayName
        self.username = model.username
    }
}
