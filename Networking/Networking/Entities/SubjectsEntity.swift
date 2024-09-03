//
//  SubjectsEntity.swift
//  Networking
//
//  Created by Ruska Keldishvili on 01.09.24.
//

public struct SubjectEntity {
    public init(id: Int?, subjectName: String?) {
        self.id = id
        self.subjectName = subjectName
    }
    
    public var id: Int?
    public var subjectName: String?
    
    // Initializer that takes a Subject model
    public init(with model: ApiSubject) {
        self.id = model.id
        self.subjectName = model.subjectName
    }
}
