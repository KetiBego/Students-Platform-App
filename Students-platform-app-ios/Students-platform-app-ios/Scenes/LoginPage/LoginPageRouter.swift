//
//  LoginPageRouter.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//


final class LoginPageRouter {
    
    func route(to route: LoginPageRoute,
               from view: LoginPageController) {
        switch route {
        case .profile:
            view.navigationController?.viewControllers = [EntryPage()]
        case .resetPassword:
            view.navigationController?.pushViewController(EntryPage(), animated: true)
        case .register:
            view.navigationController?.pushViewController(EntryPage(), animated: true)
        }
    }
}
