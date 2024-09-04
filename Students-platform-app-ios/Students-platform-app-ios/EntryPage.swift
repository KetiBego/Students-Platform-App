//
//  ViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 10.05.24.
//

//import UIKit
//import Networking
//
//class EntryPage: UIViewController {
//    
//    private let service = Service()
//
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let testButton = UIButton(type: .system)
//        
//        // Set the button title
//        testButton.setTitle("Test Button", for: .normal)
//        testButton.isEnabled = true
//        
//        testButton.isUserInteractionEnabled = true
//        
//        // Set the button's position and size
//        testButton.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
//        
//        // Set the background color (optional)
//        testButton.backgroundColor = UIColor.systemBlue
//        
//        // Set the button title color
//        testButton.setTitleColor(UIColor.white, for: .normal)
//        
//        // Add target for the button to handle the tap event
//        testButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
//        
//        // Add the button to the view
//        self.view.addSubview(testButton)
//        }
//        
//        // Function to be called when the button is pressed
//    @objc func buttonPressed() {
//        let vc = LoginPageController()
//        
//        self.navigationController?.setViewControllers([vc], animated: true)
//        
//        print("here")
//    
//    }
//    
//
//}
    
   
//    
//    func presentSecondViewController() {
//        self.navigationController?.setViewControllers([TabBarController()], animated: true)
//    }
//    



import UIKit
import MyAssetBook
import Networking

class EntryPage: UIViewController {
    
    private let service = Service()
    
    
    private var EmailValue :String = ""
    private var PasswordValue :String = ""
    
    
    private lazy var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.height(equalTo: 100)
        imageView.width(equalTo: 100)
        imageView.image =  Image.AppLogo
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var registrationButton: PrimaryButton = {
        let button = PrimaryButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var button: PrimaryButton = {
        let button = PrimaryButton()
        button.backgroundColor = Color.Yellow2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    private lazy var LoginTextLabel: LocalLabel = {
        let label = LocalLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var welcomeLabel: LocalLabel = {
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
   
    private lazy var LoginTextLabelModel: LocalLabelModel = {
        let label = LocalLabelModel(
            text: MytextBook.LoginTexts.loginLabelText,
            color: Color.Blue1,
            font: .systemFont(ofSize: .L))
        return label
    }()
    
    private lazy var emptyView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.height(equalTo: 40)
        return view
    }()
    
    private lazy var WelcomeLabelModel: LocalLabelModel = {
        let label = LocalLabelModel(
            text: MytextBook.LoginTexts.appName,
            font: .systemFont(ofSize: .XL, weight: .bold))
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
  

extension EntryPage {
    
    func setUp() {
        configureViews()
        setUpUI()
        addSubviews()
        addConstraints()
        
    }
    func configureViews() {
        LoginTextLabel.configure(with: LoginTextLabelModel)
        welcomeLabel.configure(with: WelcomeLabelModel)

        loginTextField.bind(model: .init(
            placeholder: MytextBook.LoginTexts.email,
            onEditingDidEnd: { email in
                self.EmailValue = email
        }))
        
        passwordTextField.bind(model: .init(
            placeholder: MytextBook.LoginTexts.password,
            isSecureEntry: true,
            onEditingDidEnd: { password in
                self.PasswordValue = password
            }))
        
        registrationButton.configure(with: .init(
            titleModel: .init(
                text: MytextBook.LoginTexts.registration,
                color: Color.Red,
                font: .systemFont(ofSize: .L)),
            action: { [weak self] in
                self?.navigationController?.pushViewController(RegistrationViewController(), animated: true)
            }))

        
        button.configure(with: .init(
            titleModel: .init(
                text: MytextBook.LoginTexts.loginButtonText,
                font: .systemFont(ofSize: .XL2)
            ),
            action: { [weak self] in
                self?.service.CallLoginService(for: self?.EmailValue ?? "" , password: self?.PasswordValue ?? "", completion: {[weak self] result in
                    guard let self = self else {return}
                    switch result{                   
                    case .success(let serviceResponse):
                        print(serviceResponse)
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(serviceResponse.token!, forKey: "authToken")
                            self.navigationController?.pushViewController(MyFilesViewController(), animated: true)
                        }
                    case .failure(let error):
                        print(error)
                    }
              })
                                
            }))
    }
    
    func setUpUI() {
        view.backgroundColor = Color.background
    }
    
    func addSubviews() {
        containerView.addSubview(LoginTextLabel)
        containerView.addSubview(textFieldsContainer)
        containerView.addSubview(button)
        mainStackView.addArrangedSubview(myImageView)
        mainStackView.addArrangedSubview(emptyView)
        mainStackView.addArrangedSubview(containerView)
        mainStackView.addArrangedSubview(registrationButton)
        view.addSubview(mainStackView)
        
    }
    
    func addConstraints() {
        
        emptyView.addSubview(welcomeLabel)
        welcomeLabel.centerVertically(to: emptyView)
        welcomeLabel.centerHorizontally(to: emptyView)
        LoginTextLabel.top(toView: containerView, constant: .XL3)
        LoginTextLabel.left(toView: containerView, constant: .XL3)
        
        textFieldsContainer.centerVertically(to: containerView)
        textFieldsContainer.centerHorizontally(to: containerView)

        
        textFieldsContainer.left(toView: containerView, constant: .XL2)
        textFieldsContainer.right(toView: containerView, constant: .XL2)
        
        button.relativeTop(toView: textFieldsContainer, constant: .M)
        button.left(toView: containerView, constant: .XL2)
        button.right(toView: containerView, constant: .XL2)
        button.bottom(toView: containerView)
        button.layer.cornerRadius = .S
        
        registrationButton.width(equalTo: 150)
        registrationButton.height(equalTo: 40)

        
        mainStackView.left(toView: view)
        mainStackView.right(toView: view)
        mainStackView.centerVertically(to: view)
    }
    
    override func viewDidLayoutSubviews() {
       
    }

}














