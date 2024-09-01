//
//  NavigationBar.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import MyAssetBook
public protocol CustomNavigatable {
    var navTitle: NavigationTitle { get }
    var leftBarItems: [UIBarButtonItem]? { get }
    var rightBarItems: [UIBarButtonItem]? { get }
    
    func configureNavigationBar()
}

public struct NavigationTitle {

    let text: String
    let color: UIColor
    
    public init(text: String,
                color: UIColor = Color.Blue3) {
        self.text = text
        self.color = color
    }
}

public extension CustomNavigatable where Self: UIViewController {
    
    var leftBarItems: [UIBarButtonItem]? {
        let button = BackBarButtonItem()
        button.backButtonTappedAction = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return [button]
    }
    
    var rightBarItems: [UIBarButtonItem]? {
        return nil
    }
    
    func configureNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = navTitle.text
        titleLabel.font = .boldSystemFont(ofSize: .XL2)
        titleLabel.textColor = navTitle.color
        
        let titleBarButtonItem = UIBarButtonItem(customView: titleLabel)
        
        if let leftItems = leftBarItems {
            navigationItem.leftBarButtonItems = leftItems + [titleBarButtonItem]
        } else {
            let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spacer.width = .XL
            
            navigationItem.leftBarButtonItems = [spacer, titleBarButtonItem]
        }
        
        if let rightItems = rightBarItems {
            navigationItem.rightBarButtonItems = rightItems
        }
    }

}
