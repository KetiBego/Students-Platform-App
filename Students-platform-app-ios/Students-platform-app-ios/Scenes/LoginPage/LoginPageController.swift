//
//  LoginPageController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import MyAssetBook
import Resolver
import Networking

class LoginPageController: UIViewController {
    
//    @Injected var loginUseCase: LoginUseCase

    
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
    
    private lazy var label: LocalLabel = {
        let label = LocalLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var loginTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var passwordResetLabel: LocalLabel = {
        let label = LocalLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var registrationLabel: LocalLabel = {
        let label = LocalLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.setAlignment(with: .center)
        return label
    }()
    
    private lazy var labelModel: LocalLabelModel = {
        let label = LocalLabelModel(text: "ლეიბლი")
        return label
    }()
    
    private lazy var textFieldsContainer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(loginTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.spacing = .M
        return stack
    }()
    
    private lazy var button: PrimaryButton = {
        let button = PrimaryButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUp()
//        handleLogin()
        // Create a UIButton instance
        let testButton = UIButton(type: .system)
        
        // Set the button title
        testButton.setTitle("Test Button", for: .normal)
        testButton.isEnabled = true
        
        testButton.isUserInteractionEnabled = true
        
        // Set the button's position and size
        testButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        
        // Set the background color (optional)
        testButton.backgroundColor = UIColor.systemBlue
        
        // Set the button title color
        testButton.setTitleColor(UIColor.white, for: .normal)
        
        // Add target for the button to handle the tap event
        testButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        // Add the button to the view
        self.view.addSubview(testButton)
        }
        
        // Function to be called when the button is pressed
    @objc func buttonPressed() {
        print("here")
        let nextViewController = testController()
        
        self.navigationController?.pushViewController(nextViewController, animated: true)

    }

    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    
    override func viewWillLayoutSubviews() {
    }
}

extension LoginPageController {
    func setUp() {
        setUpUI()
        addSubviews()
        addConstraints()
        label.configure(with: labelModel)
        
    }
    
    func setUpUI() {
        view.backgroundColor = Color.background
    }
    
    func addSubviews() {
        containerView.addSubview(label)
        containerView.addSubview(textFieldsContainer)
        containerView.addSubview(button)
        mainStackView.addArrangedSubview(containerView)
        view.addSubview(mainStackView)
    }
    
    func addConstraints() {
        
        label.top(toView: containerView, constant: .XL)
        label.left(toView: containerView, constant: .L)
        
        textFieldsContainer.centerVertically(to: containerView)
        textFieldsContainer.centerHorizontally(to: containerView)

        
        textFieldsContainer.left(toView: containerView, constant: .XL2)
        textFieldsContainer.right(toView: containerView, constant: .XL2)
//        textFieldsContainer.relativeTop(toView: label, constant: .XL)
        
        button.relativeTop(toView: textFieldsContainer, constant: .M)
        button.left(toView: containerView)
        button.right(toView: containerView)
        button.bottom(toView: containerView)
        
        mainStackView.left(toView: view)
        mainStackView.right(toView: view)
        mainStackView.centerVertically(to: view)
    }
    
    override func viewDidLayoutSubviews() {
       
    }
    
//    private func handleLogin() {
//        loginUseCase.loginUser(email: "rkeld",
//                                password: "12345678")
//        
//    }
    
}


class testController: UIViewController {
    
    @Injected var loginUseCase: LoginUseCase

    override func viewDidLoad() {
        handleLogin()
    }
    
    private func handleLogin() {
        loginUseCase.loginUser(email: "rkeld",
                                password: "12345678")
        
    }
    
}


