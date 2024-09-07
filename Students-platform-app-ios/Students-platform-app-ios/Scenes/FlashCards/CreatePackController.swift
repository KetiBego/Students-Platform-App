//
//  CreatePackController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//


import UIKit
import MyAssetBook

class CreateFlashcardPackViewController: UIViewController {
    
    private var name: String? = nil
    
    private lazy var nameTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var createButton: PrimaryButton = {
        let button = PrimaryButton()
        button.layer.cornerRadius = .S
        button.backgroundColor = Color.Emerald
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cancelButton: PrimaryButton = {
        let button = PrimaryButton()
        button.layer.cornerRadius = .S
        button.backgroundColor = Color.Red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = .S
        return view
    }()
    
    var onCreate: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        nameTextField.bind(model: .init(
            placeholder: "სახელი",
            onEditingDidEnd: { [weak self] text in
                self?.name = text
            }))
        
        createButton.configure(with: .init(
            titleModel: .init(
                text: "შექმნა",
                color: .white,
                font: .systemFont(ofSize: .L)),
            action: { [weak self] in
                self?.createButtonTapped()
            }))
        
        cancelButton.configure(with: .init(
            titleModel: .init(
                text: "გაუქმება",
                color: .white,
                font: .systemFont(ofSize: .L)),
            action: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }))
        
        view.addSubview(containerView)
        containerView.addSubview(nameTextField)
        containerView.addSubview(createButton)
        containerView.addSubview(cancelButton)
        containerView.backgroundColor = Color.background
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 250),
            
            nameTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            createButton.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            createButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            cancelButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func createButtonTapped() {
        if let name = self.name {
            onCreate?(name)
            dismiss(animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                self.displayBanner(with: "შეფერხებაა, მოგვიანებით სცადე", state: .failure)
            }
        }
    }
}
