//
//  GateWayInjection.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

import Resolver

extension Resolver {
    
    public static func registerGateways() {
        register(LoginGateway.self) { LoginGatewayImpl() }
    }
}

extension Resolver {
    
    public static func registerNetworkLayer() {
        register(NetworkLayer.self) { NetworkService() }.scope(.application)
    }
}

