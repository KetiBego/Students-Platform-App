//
//  ProviderRegistration.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

import Resolver

extension Resolver {
    
    public static func registerCoreProviders() {
        register(ApiURLProvider.self) { ApiUURLProviderImpl() }.scope(.application)
    }
}
