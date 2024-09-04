//
//  RegistrationViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 03.09.24.
//

import UIKit
import MyAssetBook
import Networking
import Lottie

class RegistrationViewController: UIViewController, CustomNavigatable {
    
    private let service = Service()
    
    private var emailValue: String = ""
    private var usernameValue: String = ""
    private var passwordValue: String = ""
    
    let animationView: LottieAnimationView = {
        let animation = LottieAnimationView()
        animation.translatesAutoresizingMaskIntoConstraints = false
        animation.loopMode = .loop
        animation.animation = .named(MyLottie.registrationAnimation, bundle: Bundle(identifier: "Free-University.MyAssetBook")!)
        animation.height(equalTo: 250)
        animation.width(equalTo: 200)
        return animation
    }()
    
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(equalTo: 40)
        return view
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.background
        return view
    }()
    
    private lazy var registrationTextLabel: LocalLabel = {
        let label = LocalLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var emailTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var usernameTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var registrationButton: PrimaryButton = {
        let button = PrimaryButton()
        button.backgroundColor = Color.Yellow2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var textFieldsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(emailTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.spacing = .M
        return stack
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
}

extension RegistrationViewController {
    
    func setUp() {
        configureViews()
        setUpUI()
        addSubviews()
        addConstraints()
    }
    
    func configureViews() {
        registrationTextLabel.configure(with: .init(
            text: MytextBook.RegistrationTexts.registrationLabelText,
            font: .systemFont(ofSize: .L)))
        
        emailTextField.bind(model: .init(
            placeholder: MytextBook.RegistrationTexts.email,
            onEditingDidEnd: { email in
                self.emailValue = email
        }))
        
        usernameTextField.bind(model: .init(
            placeholder: MytextBook.RegistrationTexts.username,
            onEditingDidEnd: { username in
                self.usernameValue = username
        }))
        
        passwordTextField.bind(model: .init(
            placeholder: MytextBook.RegistrationTexts.password,
            isSecureEntry: false,
            onEditingDidEnd: { password in
                self.passwordValue = password
        }))
        
        registrationButton.configure(with: .init(
            titleModel: .init(
                text: MytextBook.RegistrationTexts.registerButtonText,
                font: .systemFont(ofSize: .XL2)
            ),
            action: { [weak self] in
                guard let self = self else { return }
                self.service.CallRegisterUserService(email: self.emailValue, username: self.usernameValue, password: self.passwordValue, schoolId: 1) { result in
                    switch result {
                    case .success(let response):
                        print(response)
                        DispatchQueue.main.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
                
                
            }))
    }
    
    func setUpUI() {
        view.backgroundColor = Color.background
    }
    
   
    func addSubviews() {
        containerView.addSubview(registrationTextLabel)
        containerView.addSubview(textFieldsContainer)
        containerView.addSubview(registrationButton)
        mainStackView.addArrangedSubview(animationView)
        animationView.play()
        mainStackView.addArrangedSubview(emptyView)
        mainStackView.addArrangedSubview(containerView)
        view.addSubview(mainStackView)
    }
    
    func addConstraints() {
        
        registrationTextLabel.top(toView: containerView, constant: .XL3)
        registrationTextLabel.left(toView: containerView, constant: .XL3)
        
        textFieldsContainer.centerVertically(to: containerView)
        textFieldsContainer.centerHorizontally(to: containerView)

        
        textFieldsContainer.left(toView: containerView, constant: .XL2)
        textFieldsContainer.right(toView: containerView, constant: .XL2)
//        textFieldsContainer.relativeTop(toView: label, constant: .XL)
        
        registrationButton.relativeTop(toView: textFieldsContainer, constant: .M)
        registrationButton.left(toView: containerView, constant: .XL2)
        registrationButton.right(toView: containerView, constant: .XL2)
        registrationButton.bottom(toView: containerView)
        registrationButton.layer.cornerRadius = .S
        
        mainStackView.left(toView: view)
        mainStackView.right(toView: view)
        mainStackView.centerVertically(to: view)
    }

    
    override func viewDidLayoutSubviews() {
        // Any additional layout adjustments
    }
    
    
    var navTitle: NavigationTitle {
        .init(text: "რეგისტრაცია", color: Color.Blue1)
    }
}
