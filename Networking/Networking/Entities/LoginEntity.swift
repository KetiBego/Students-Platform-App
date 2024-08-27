//
//  LoginEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

public struct LoginEntity {
    public init(id: Int64?, email : String?, username: String?) {
        self.id = id
        self.email = email
        self.username = username
    }
    
    private var id: Int64?
    private var email: String?
    private var username: String?
    
    
    public init(with model: ApiLoginModel) {
        self.id = model.id
        self.email = model.email
        self.username = model.username
    }
}
