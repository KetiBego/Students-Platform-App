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
    }
}
    
    
enum ServiceError: Error{
    case noData
    case invalidParameters
    case SessionErrorOccurred
    case DecoderError
}

