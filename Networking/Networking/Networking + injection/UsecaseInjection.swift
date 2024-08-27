//
//  UsecaseInjection.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

import Resolver

extension Resolver {
    
    public static func registerUseCases() {
        register(LoginUseCase.self) { LoginUseCaseImpl() }
    }
}
