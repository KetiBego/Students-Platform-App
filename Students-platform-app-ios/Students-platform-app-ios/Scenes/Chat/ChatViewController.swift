//
//  ChatViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import UIKit
import Networking
import MyAssetBook

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomNavigatable {

    private var conversations: [ConversationEntity] = []
    private let tableView = UITableView()
    private let service = Service()
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.background
        configureNavigationBar()
        setUp()
        tableView.estimatedRowHeight = 100
        fetchConversations()
    }

    private func setUp() {
        setupTableView()
        setupRefreshControl()
        addSubviews()
        addConstraints()
    }

    private func setupTableView() {
        tableView.backgroundColor = Color.background
        tableView.backgroundView?.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ConversationTableViewCell.self, forCellReuseIdentifier: "ConversationCell")
    }

    private func setupRefreshControl() {
        // Setup refresh control and add it to the table view
        refreshControl.addTarget(self, action: #selector(refreshConversations), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc private func refreshConversations() {
        // Fetch conversations
        service.fetchUserConversations { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // Add delay to showcase the animation
                switch result {
                case .success(let conversationResponse):
                    self?.conversations = conversationResponse.conversationInfos
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch conversations: \(error)")
                }

                self?.refreshControl.endRefreshing()
            }
        }
    }

    private func addSubviews() {
        view.addSubview(tableView)
        view.backgroundColor = Color.background
    }

    private func addConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func fetchConversations() {
        service.fetchUserConversations { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let conversationResponse):
                    self?.conversations = conversationResponse.conversationInfos
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch conversations: \(error)")
                }

            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return .XL8 // Set your desired height
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
        let chatDetailVC = ChatDetailsViewController(recipientUserId: conversation.userId!, recipientUserName: conversation.username!)
        navigationController?.pushViewController(chatDetailVC, animated: true)
    }

    var navTitle: NavigationTitle {
        .init(text: "მიმოწერები", color: Color.Blue1)
    }

    var rightBarItems: [UIBarButtonItem]? {
        let button = AddBarButtonItem()
        button.addButtonTappedAction = { [weak self] in
            self?.presentConversationAddController()
        }
        return [button]
    }

    var leftBarItems: [UIBarButtonItem]? { nil }

    private func presentConversationAddController() {
        let createVC = NewConvoStarterController()
        self.present(createVC, animated: true, completion: nil)
        self.fetchConversations()
    }
}
