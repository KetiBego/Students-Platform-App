//
//  ApiMyFile.swift
//  Networking
//
//  Created by Ruska Keldishvili on 04.09.24.
//

public struct ApiMyFile: Decodable{
    var id: Int?
    var username: String?
    var subjectName: String?
    var fileName: String?
    var upvoteCount: Int?
    var isUpvoted: Bool?    
}
