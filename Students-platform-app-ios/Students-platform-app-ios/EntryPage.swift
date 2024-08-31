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
    
    
    private var EmailValue:String?
    private var PasswordValue:String?
    
    
    private lazy var myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.height(equalTo: 100)
        imageView.width(equalTo: 100)
        // Set the image to your UIImage (you can replace "yourImageName" with the actual image name)
        imageView.image =  Image.AppLogo
        
        // Set additional properties like content mode, if necessary
        imageView.contentMode = .scaleAspectFit
        
        return imageView
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
    
    //    private lazy var registrationLabel: LocalLabel = {
    //        let label = LocalLabel()
    //        label.translatesAutoresizingMaskIntoConstraints = false
    //        label.backgroundColor = .clear
    //        label.setAlignment(with: .center)
    //        return label
    //    }()
    //
    private lazy var LoginTextLabelModel: LocalLabelModel = {
        let label = LocalLabelModel(
            text: MytextBook.LoginTexts.loginLabelText,
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
    
    private lazy var button: PrimaryButton = {
        let button = PrimaryButton()
        button.backgroundColor = Color.Yellow2
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
  
//        self.navigationController?.pushViewController(nextViewController, animated: true)

    


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
            onEditingDidEnd: { email in
                self.PasswordValue = email
            }))
        button.configure(with: .init(
            titleModel: .init(
                text: MytextBook.LoginTexts.loginButtonText,
                font: .systemFont(ofSize: .XL2)
            ),
            action: { [weak self] in
                self?.service.CallLoginService(for: "rkeld20@freeuni.edu.ge", password: "12345678", completion: {[weak self] result in
                    guard let self = self else {return}
                    switch result{
                    case .success(let serviceResponse):
                        print(serviceResponse)
                    case .failure(let error):
                        print(error)
                    }
                })
                self?.navigationController?.pushViewController(TabBarController(), animated: true)
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
//        textFieldsContainer.relativeTop(toView: label, constant: .XL)
        
        button.relativeTop(toView: textFieldsContainer, constant: .M)
        button.left(toView: containerView, constant: .XL2)
        button.right(toView: containerView, constant: .XL2)
        button.bottom(toView: containerView)
        button.layer.cornerRadius = .S
        
        mainStackView.left(toView: view)
        mainStackView.right(toView: view)
        mainStackView.centerVertically(to: view)
    }
    
    override func viewDidLayoutSubviews() {
       
    }

}














