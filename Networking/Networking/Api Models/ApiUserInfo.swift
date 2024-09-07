//
//  ApiUserInfo.swift
//  Networking
//
//  Created by Ruska Keldishvili on 07.09.24.
//

public struct ApiUserInfo: Decodable {
    let id: Int
    let displayName: String
    let username: String
}
