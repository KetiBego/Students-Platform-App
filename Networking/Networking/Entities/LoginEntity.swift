//
//  LoginEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

public struct LoginEntity {
    public init(id: Int?, email : String?, username: String?, token: String?) {
        self.id = id
        self.email = email
        self.username = username
        self.token = token
    }
    
    public var id: Int?
    public var email: String?
    public var username: String?
    public var token: String?

    
    public init(with model: ApiLoginModel) {
        self.id = model.id
        self.email = model.email
        self.username = model.username
        self.token = model.token
    }
}
