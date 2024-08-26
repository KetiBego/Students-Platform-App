//
//  ApiLoginModel.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

public struct ApiLoginModel: Codable {
    var successful: Bool?
    var userType: String?
    var userId: Int64?
    var idByRole: Int64?
}
