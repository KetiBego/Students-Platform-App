//
//  Endpoint.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public class Service{
    
    public init(){}
    
    public struct UrlStrings {
        public static let loginUrl = "http://localhost:8080/api/v1/user/signIn"
        public static let subjectsUrl = "http://localhost:8080/api/v1/subjects/all"
        public static let mySubjectsUrl = "http://localhost:8080/api/v1/user/subjects"
        public static let addSubjects = "http://localhost:8080/api/v1/user/subjects/add"
        public static let deleteSubject  = "http://localhost:8080/api/v1/user/subjects"
        public static let registerUrl = "http://localhost:8080/api/v1/user"
    }
}
    
    
enum ServiceError: Error{
    case noData
    case responseError
    case invalidBody
    case invalidParameters
    case SessionErrorOccurred
    case DecoderError
}

