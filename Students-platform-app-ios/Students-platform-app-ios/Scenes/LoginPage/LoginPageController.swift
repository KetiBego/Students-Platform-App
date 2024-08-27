//
//  LoginPageController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 26.08.24.
//

import UIKit
import MyAssetBook
import Combine
//import Resolver

class LoginPageController: UIViewController {
    
    private var viewModel: LoginPageViewModel = LoginPageViewModel()
//    @Injected private var router: LoginPageRouter
    
    private var subscriptions = Set<AnyCancellable>()

    
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
        setUp()
//        bindRouter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
}

extension LoginPageController {
    func setUp() {
        setUpUI()
        addSubviews()
        addConstraints()
        configureUI()
        
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
        
        textFieldsContainer.left(toView: containerView, constant: .XL2)
        textFieldsContainer.right(toView: containerView, constant: .XL2)
        textFieldsContainer.relativeTop(toView: label, constant: .XL)
        
        button.relativeTop(toView: textFieldsContainer, constant: .M)
        button.left(toView: containerView)
        button.right(toView: containerView)
        button.bottom(toView: containerView)
        
        mainStackView.left(toView: view)
        mainStackView.right(toView: view)
        mainStackView.bottom(toView: view, constant: -.M)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let path = UIBezierPath(roundedRect: mainStackView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: .XL,
                                                    height: .XL))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        mainStackView.layer.mask = maskLayer
    }
}

//extension LoginPageController {
//    
//    private func bindRouter() {
//        viewModel.getRouter()
//            .compactMap { $0 }
//            .sink { [weak self] route in
//                guard let self = self else { return }
//                self.router.route(to: route, from: self)
//            }.store(in: &subscriptions)
//    }
//}


extension LoginPageController {
    
    private func configureUI() {
        viewModel.labelModel.sink {[weak self] model in
            self?.label.bind(with: model)
        }.store(in: &subscriptions)
        
        viewModel.emailModel.sink { [weak self] model in
            self?.loginTextField.bind(model: model)
        }.store(in: &subscriptions)
        
        viewModel.passwordModel.sink { [weak self] model in
            self?.passwordTextField.bind(model: model)
        }.store(in: &subscriptions)
        
        viewModel.continueButtonModel.sink { [weak self] model in
            self?.button.bind(with: model)
        }.store(in: &subscriptions)
        
        viewModel.passwordResetLabelModel.sink {[weak self] model in
            self?.passwordResetLabel.bind(with: model)
        }.store(in: &subscriptions)
        
        viewModel.RegistrationLabelModel.sink {[weak self] model in
            self?.registrationLabel.bind(with: model)
        }.store(in: &subscriptions)
        viewModel.displayBannerPublisher.sink { [weak self] statusBannerModel in
            self?.displayBanner(with: statusBannerModel.description,
                                state: statusBannerModel.bannerType)
        }.store(in: &subscriptions)
    }
}
