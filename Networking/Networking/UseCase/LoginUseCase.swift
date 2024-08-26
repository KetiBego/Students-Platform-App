//
//  LoginUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

import Combine
import Resolver

public protocol LoginUseCase {
    func loginUser(email: String,
                   password: String) -> AnyPublisher<LoginEntity, Error>
}

public class LoginUseCaseImpl: LoginUseCase {
    
    @Injected var loginGateway: LoginGateway
    
    public func loginUser(email: String,
                          password: String) -> AnyPublisher<LoginEntity, Error> {
        loginGateway.loginUser(email: email, password: password)
    }
}
