//
//  MyFileEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 04.09.24.
//

public struct MyFileEntity {
    public init(
        id: Int?,
        username: String?,
        subjectName: String?,
        fileName: String?,
        upvoteCount: Int?,
        isUpvoted: Bool?
    ) {
        self.id = id
        self.username = username
        self.subjectName = subjectName
        self.fileName = fileName
        self.upvoteCount = upvoteCount
        self.isUpvoted = isUpvoted
    }
    
    public var id: Int?
    public var username: String?
    public var subjectName: String?
    public var fileName: String?
    public var upvoteCount: Int?
    public var isUpvoted: Bool?
    
    
    public init(with model: ApiMyFile) {
        self.id = model.id
        self.username = model.username
        self.subjectName = model.subjectName
        self.fileName = model.fileName
        self.upvoteCount = model.upvoteCount
        self.isUpvoted = model.isUpvoted

    }
    
}
