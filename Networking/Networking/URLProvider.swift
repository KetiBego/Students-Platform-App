//
//  URLProvider.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

public protocol ApiURLProvider {
    func getURL(path: String,
                params: [String: String]) -> URL?
}

public struct ApiUURLProviderImpl: ApiURLProvider {

    public func getURL(path: String,
                       params: [String: String]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = domainURL
        components.path = path
        components.queryItems = params.map({ key, value in
            URLQueryItem(name: key, value: value)
        })
        return components.url
    }

    private var domainURL: String {
        "989b-217-147-224-170.ngrok-free.app"
    }
}
