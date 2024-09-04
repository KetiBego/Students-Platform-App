//
//  NavigationBackButton.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import MyAssetBook

public class BackBarButtonItem: UIBarButtonItem {
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = Color.Blue3
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backButtonTapped)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
//        view.layer.borderWidth = 1
//        view.layer.borderColor = BrandBookManager.Color.Theme.Background.popup.cgColor
        return view
    }()
    
    var backButtonTappedAction: (() -> Void)?
    
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
       
        containerView.width(equalTo: .XL5)
        containerView.height(equalTo: .XL5)
        containerView.layer.cornerRadius = .XL5 / 2
    }
    
    private func addSubviews() {
        containerView.addSubview(button)
        customView = containerView
    }
    
    @objc private func backButtonTapped() {
        backButtonTappedAction?()
    }
}



public class AddBarButtonItem: UIBarButtonItem {
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "doc.badge.plus"), for: .normal)
        button.tintColor = Color.Blue3
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addButtonTapped)))
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.background
//        view.layer.borderWidth = 1
//        view.layer.borderColor = BrandBookManager.Color.Theme.Background.popup.cgColor
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
