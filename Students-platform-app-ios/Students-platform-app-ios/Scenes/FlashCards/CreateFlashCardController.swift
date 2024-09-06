//
//  CreateFlashCardController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import MyAssetBook

class AddFlashcardViewController: UIViewController {
    
    private var question: String? = nil
    private var answer: String? = nil
    
    private lazy var questionTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bind(model: .init(
            placeholder: "Enter Question",
            onEditingDidEnd: { [weak self] text in
                self?.question = text
            }))
        return textField
    }()
    
    private lazy var answerTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bind(model: .init(
            placeholder: "Enter Answer",
            onEditingDidEnd: { [weak self] text in
                self?.answer = text
            }))
        return textField
    }()
    
    private lazy var createButton: PrimaryButton = {
        let button = PrimaryButton()
        button.layer.cornerRadius = .S
        button.backgroundColor = Color.Yellow2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(with: .init(
            titleModel: .init(
                text: "Create",
                color: .white,
                font: .systemFont(ofSize: .L)),
            action: { [weak self] in
                self?.createButtonTapped()
            }))
        return button
    }()
    
    private lazy var cancelButton: PrimaryButton = {
        let button = PrimaryButton()
        button.layer.cornerRadius = .S
        button.backgroundColor = Color.Red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(with: .init(
            titleModel: .init(
                text: "Cancel",
                color: .white,
                font: .systemFont(ofSize: .L)),
            action: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }))
        return button
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = .S
        return view
    }()
    
    var onCreate: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        view.addSubview(containerView)
        containerView.addSubview(questionTextField)
        containerView.addSubview(answerTextField)
        containerView.addSubview(createButton)
        containerView.addSubview(cancelButton)
        containerView.backgroundColor = Color.background
        
        // Layout Constraints
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            questionTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            questionTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            questionTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            answerTextField.topAnchor.constraint(equalTo: questionTextField.bottomAnchor, constant: 20),
            answerTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            answerTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            createButton.topAnchor.constraint(equalTo: answerTextField.bottomAnchor, constant: 20),
            createButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            createButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            cancelButton.topAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 10),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func createButtonTapped() {
        if let question = self.question, let answer = self.answer {
            onCreate?(question, answer)
            dismiss(animated: true, completion: nil)
        } else {
            // Show error if needed
        }
    }
}
