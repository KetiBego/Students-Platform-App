//
//  ApiLoginModel.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

public struct ApiLoginModel: Codable {
    var id: Int?
    var email: String?
    var username: String?
    var token: String?
}
