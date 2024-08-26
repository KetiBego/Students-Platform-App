//
//  LoginEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

public struct LoginEntity {
    public init(userType: UserType, userId: Int64? = nil, generalID: Int64? = nil) {
        self.userType = userType
        self.userId = userId
        self.generalID = generalID
    }
    
    public var userType: UserType
    public var userId: Int64?
    public var generalID: Int64?
    
    public init(with model: ApiLoginModel) {
        self.userType = UserType(rawValue: model.userType ?? "") ?? .none
        self.userId = model.idByRole
        self.generalID = model.userId
    }
}


public enum UserType: String {
    case student = "STUDENT"
    case teacher = "TEACHER"
    case none
}
