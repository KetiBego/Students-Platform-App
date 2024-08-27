//
//  TestFile.swift
//  Networking
//
//  Created by Ruska Keldishvili on 10.05.24.
//

import Resolver

public class Test {
    public init() {}
    
    public func printHello() {
        print("Hello")
    }
}

extension Resolver: ResolverRegistering {
    
    public static func registerAllServices() {
        registerCoreProviders()
    }
    

    public static func registerCoreProviders() {
        register(ApiURLProvider.self) { ApiUURLProviderImpl() }.scope(.application)
    }

    
}




