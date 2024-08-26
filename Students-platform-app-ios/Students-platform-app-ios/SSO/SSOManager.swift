//
//  SSOManager.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import Combine
import Networking

public protocol SSOManager {
    var isUserLoggedPublisher: Published<Bool>.Publisher { get }
    var userInfo: LoginEntity? { get }
    var userEmail: String? { get }
    
    func userLoggedInSuccessfully(userEmail: String?,
                                  with userLoginModel: LoginEntity)
    
    func logOutUser()
}

public class SSOManagerImpl: SSOManager {
    
    public var userInfo: LoginEntity?
    
    @Published private var isUserLogged: Bool = false
    
    public var isUserLoggedPublisher: Published<Bool>.Publisher { $isUserLogged }
    
    public var userEmail: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    public init() { }
    
    public func userLoggedInSuccessfully(userEmail: String?,
                                         with userLoginModel: LoginEntity) {
        self.userInfo = userLoginModel
        self.userEmail = userEmail
        isUserLogged = true
    }
    
    public func logOutUser() {
        userInfo = nil
        userEmail = nil
        isUserLogged = false
    }
}
