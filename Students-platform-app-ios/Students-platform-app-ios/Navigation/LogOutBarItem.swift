//
//  LogOutBarItem.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 07.09.24.
//

import UIKit
import MyAssetBook

public class LogOutBarButtonItem: UIBarButtonItem {
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "door.left.hand.open"), for: .normal)
        button.tintColor = Color.Blue3
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonTapped)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.background

        return view
    }()
    
    var addButtonTappedAction: (() -> Void)?
    
    override init() {
        super.init()
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        addSubviews()
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.top(toView: containerView)
        button.bottom(toView: containerView)
        button.left(toView: containerView)
        button.right(toView: containerView)
       
        containerView.width(equalTo: .XL6)
        containerView.height(equalTo: .XL6)
        containerView.layer.cornerRadius = .XL6 / 2
    }
    
    private func addSubviews() {
        containerView.addSubview(button)
        customView = containerView
    }
    
    @objc private func addButtonTapped() {
        addButtonTappedAction?()
    }
}
