//
//  LoginGateway.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

import Combine
import Resolver

public protocol LoginGateway {
    func loginUser(email: String,
                   password: String) -> AnyPublisher<LoginEntity, Error>
}

public class LoginGatewayImpl: LoginGateway {
    
    @Injected var dataTransport: NetworkLayer
    @Injected var apiURLProvider: ApiURLProvider
    
    public func loginUser(email: String,
                          password: String) -> AnyPublisher<LoginEntity, Error> {
        
        let params = ["email": email,
                      "password": password]
        
        let url = apiURLProvider.getURL(path: "/emis/api/authentication/login",
                                        params: params)
        
        let endpoint = EndPoint<ApiLoginModel>(url: url,
                                               method: .post)
        
        let publisher: AnyPublisher<LoginEntity, Error> = dataTransport.makeRequest(endpoint)
            .map { apiLoginModel in
                return LoginEntity(with: apiLoginModel)
            }
            .eraseToAnyPublisher()
        
        return publisher
    }
}
