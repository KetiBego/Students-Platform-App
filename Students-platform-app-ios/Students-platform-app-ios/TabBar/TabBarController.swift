//
//  TabBarController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import MyAssetBook

class TabBarController: UITabBarController {
    
    var Subjects: TabBarItem = .Subjects
    var Search: TabBarItem = .Search
    var Chat: TabBarItem = .Chat
    var Profile: TabBarItem = .Profile


    override func viewDidLoad() {
        super.viewDidLoad()
        createViewControllers()
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //round tab Bar
        let path = UIBezierPath(roundedRect: tabBar.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: .L,
                                                    height: .L))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.borderColor = Color.Blue2.cgColor
        tabBar.layer.mask = maskLayer
    }
    
    private func setUpUI() {
        
        tabBar.backgroundColor =  Color.Yellow2
        
        let appearance = self.tabBar.standardAppearance.copy()
        appearance.stackedLayoutAppearance.normal.iconColor = Color.Blue1
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: Color.Blue1,
            .font : UIFont.systemFont(ofSize: .M)
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = Color.Blue3
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: Color.Blue3,
            .font : UIFont.systemFont(ofSize: .L)
        ]
        
        self.tabBar.standardAppearance = appearance
    }
    
    public func createViewControllers() {
        let firstTab = UINavigationController(rootViewController: Subjects.controller)
        let secondTab = UINavigationController(rootViewController: Search.controller)
        let thirdTab = UINavigationController(rootViewController: Chat.controller)
        let fourthTab = UINavigationController(rootViewController: Profile.controller)

        viewControllers = [firstTab, secondTab,thirdTab, fourthTab]
        
        
        firstTab.tabBarItem = UITabBarItem(title: Subjects.text, image: Subjects.icon.resizeImage(targetSize: .init(width: .XL4, height: .XL3)), tag: 0)
        secondTab.tabBarItem = UITabBarItem(title: Search.text, image: Search.icon.resizeImage(targetSize: .init(width: .XL4, height: .XL3)), tag: 1)
        thirdTab.tabBarItem = UITabBarItem(title: Chat.text, image: Chat.icon.resizeImage(targetSize: .init(width: .XL4, height: .XL3)), tag: 2)
        fourthTab.tabBarItem = UITabBarItem(title: Profile.text, image: Profile.icon.resizeImage(targetSize: .init(width: .XL4, height: .XL3)), tag: 3)
    }
}
