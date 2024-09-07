//
//  chatDetailsViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking
import MyAssetBook

class ChatDetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CustomNavigatable {

    private var messages: [PostMessageEntity] = []
    private let tableView = UITableView()
    private let messageInputField = TextFieldView()
    private let sendButton = UIButton()
    private let service = Service()
    private let recipientUserId: Int
    private var conversationId: Int?
    private var recipientUserName: String

    
    private var messageTextToBeSent: String? = nil
    
    init(recipientUserId: Int, recipientUserName: String) {
        self.recipientUserId = recipientUserId
        self.recipientUserName = recipientUserName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.background
        configureNavigationBar()
        setupViews()
        setupConstraints()
        createConversation()
    }

    private func setupViews() {
        view.backgroundColor = Color.background
        
        tableView.backgroundView?.backgroundColor = Color.background
        tableView.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "MessageCell")
        
        messageInputField.translatesAutoresizingMaskIntoConstraints = false
        messageInputField.bind(model: .init(
            placeholder: "Type a message...",
            onEditingDidEnd: { [weak self] text in
                self?.messageTextToBeSent = text
            }
        ))
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.systemBlue, for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        view.addSubview(tableView)
        view.addSubview(messageInputField)
        view.addSubview(sendButton)
    }

    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        messageInputField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInputField.topAnchor),
            
            messageInputField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            messageInputField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            messageInputField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -8),
            messageInputField.heightAnchor.constraint(equalToConstant: 44),
            
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: messageInputField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func createConversation() {
        service.startConversation(recipientUserId: recipientUserId) { [weak self] result in
            switch result {
            case .success(let response):
                self?.conversationId = response.conversationId
                self?.messages = response.messages.reversed()
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.scrollToBottom()
                }
            case .failure(let error):
                print("Failed to start conversation: \(error)")
            }
        }
    }

    @objc private func sendMessage() {
        guard let conversationId = conversationId,
              let messageText = messageTextToBeSent else { return }
        
        service.sendMessage(conversationId: conversationId, message: messageText) { [weak self] result in
            switch result {
            case .success:
                self?.messageTextToBeSent = nil
                self?.messageInputField.resetSubscriptions()
                self?.createConversation()
            case .failure(let error):
                print("Failed to send message: \(error)")
            }
        }
    }

    private func scrollToBottom() {
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        if messages.count > 0 {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageTableViewCell
        let message = messages[indexPath.row]
        
        let isCurrentUser = message.senderId != recipientUserId
        
        cell.configure(with: message, isCurrentUser: isCurrentUser)
        return cell
    }
    
    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
    
    var navTitle: NavigationTitle {
        .init(text: "\(recipientUserName)", color: Color.Blue1)
    }
    
}


