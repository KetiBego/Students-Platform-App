//
//  NetworkManager.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

import Combine

// for using this network layer by dependency Injection
public class NetworkService: NetworkLayer {
    private let networkManager: NetworkLayer
    
    public init(networkManager: NetworkLayer = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    public func makeRequest<T: Decodable, R: Endpoint>(_ endpoint: R) -> AnyPublisher<T, Error> where R.Response == T {
        networkManager.makeRequest(endpoint)
    }
}
