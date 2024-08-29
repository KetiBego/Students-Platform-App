//
//  RegisteringResolver.swift
//  Networking
//
//  Created by Ruska Keldishvili on 28.08.24.
//

import Resolver

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
//        registerRouters()
        registerNetworkLayer()
        registerGateways()
        registerUseCases()
        registerCoreProviders()
    }
}

