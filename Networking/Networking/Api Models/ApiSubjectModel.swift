//
//  ApiSubjectModel.swift
//  Networking
//
//  Created by Ruska Keldishvili on 01.09.24.
//

public struct ApiSubjectResponse: Codable {
    let subjects: [ApiSubject]
}

public struct ApiSubject: Codable {
    let id: Int?
    let subjectName: String?
}
