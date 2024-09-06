//
//  ChatViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var conversations: [ConversationEntity] = []
    private let tableView = UITableView()
    private let service = Service()

    override func viewDidLoad() {
        super.viewDidLoad()
//        configureNavigationBar()
        setUp()
        tableView.estimatedRowHeight = 100
        view.backgroundColor = UIColor.white // Customize as needed
        fetchConversations()
    }

    private func setUp() {
        setupTableView()
        addSubviews()
        addConstraints()
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func setupTableView() {
        tableView.backgroundColor = UIColor.white // Customize as needed
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: "ConversationCell")
    }

    private func fetchConversations() {
        service.fetchUserConversations { [weak self] result in
            switch result {
            case .success(let conversationResponse):
                self?.conversations = conversationResponse.conversationInfos
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch conversations: \(error)")
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as! ConversationTableViewCell
        let conversation = conversations[indexPath.row]
        cell.configure(with: conversation)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = conversations[indexPath.row]
    }
//        let chatDetailVC = ChatDetailViewController(conversationId: conversation.conversationId, userId: conversation.userId)
//        navigationController?.pushViewController(chatDetailVC, animated: true)
//    }

//    private func configureNavigationBar() {
//        navigationItem.title = "Conversations"
//    }
}
