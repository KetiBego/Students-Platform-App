//
//  NewConvoStarterController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 07.09.24.
//

import UIKit
import Networking
import Combine
import MyAssetBook

class NewConvoStarterController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private var recipients: [RecipientEntity] = []
    private var filteredRecipients: [RecipientEntity] = []
    private let tableView = UITableView()
    private let service = Service()
    private var subscriptions = Set<AnyCancellable>()
    
    // Search bar components
    private lazy var searchTextField: TextFieldView = {
        let textField = TextFieldView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let searchIcon: UIImageView = {
        let imageView = UIImageView(image: Icons.search.image.resizeImage(targetSize: .init(width: .XL4, height: .XL3)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = Color.Blue2
        return imageView
    }()
    
    // Container view for searchTextField and search icon
    private let searchContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.Yellow2
        view.layer.cornerRadius = 8.0
        view.height(equalTo: .XL7)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.backgroundColor = Color.background
        fetchRecipients()
        setupSearch()
    }

    private func setUp() {
        setupTableView()
        addSubviews()
        addConstraints()
    }

    private func setupTableView() {
        self.tableView.backgroundView?.backgroundColor = Color.background
        self.tableView.backgroundColor = Color.background
        tableView.backgroundView?.backgroundColor = Color.background
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipientCell")
    }

    private func addSubviews() {
        
        searchTextField.bind(model: .init(
            placeholder: MytextBook.SearchTexts.search,
            onEditingDidEnd: { subject in
                print(subject)
        }))
        
        view.addSubview(searchContainerView)
        searchContainerView.addSubview(searchTextField)
        searchContainerView.addSubview(searchIcon)
        view.addSubview(tableView)
    }

    private func addConstraints() {
        // Search icon constraints
        searchIcon.left(toView: searchContainerView, constant: .L)
        searchIcon.centerVertically(to: searchContainerView)
        
        // Search text field constraints
        searchTextField.centerVertically(to: searchContainerView)
        searchTextField.relativeLeft(toView: searchIcon, constant: .L)
        searchTextField.right(toView: searchContainerView)
        
        // Search container constraints
        searchContainerView.top(toView: view, constant: .XL)
        searchContainerView.left(toView: view, constant: .XL)
        searchContainerView.right(toView: view, constant: .XL)
        
        // Table view constraints
        tableView.relativeTop(toView: searchContainerView, constant: .XL2)
        tableView.left(toView: view)
        tableView.right(toView: view)
        tableView.bottom(toView: view)
    }

    private func setupSearch() {
        searchTextField.textPublisher
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.filterRecipients(with: searchText ?? "")
            }
            .store(in: &subscriptions)
    }
    
    private func filterRecipients(with searchText: String) {
        if searchText.isEmpty {
            filteredRecipients = recipients
        } else {
            filteredRecipients = recipients.filter { recipient in
                return recipient.username.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }

    private func fetchRecipients() {
        service.fetchRecipients { [weak self] result in
            switch result {
            case .success(let recipientEntities):
                self?.recipients = recipientEntities
                self?.filteredRecipients = recipientEntities
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch recipients: \(error)")
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipientCell", for: indexPath)
        let recipient = filteredRecipients[indexPath.row]
        cell.textLabel?.text = recipient.username
        cell.backgroundColor = Color.background
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipient = filteredRecipients[indexPath.row]
       
        service.startConversation(recipientUserId: recipient.id) { [weak self] result in
           switch result {
           case .success:
               DispatchQueue.main.async {
                   self?.dismiss(animated: true, completion: {
                       print("Selected recipient: \(recipient.username)")
                   })
               }
           case .failure(let error):
               // Handle the error case (e.g., show an alert)
               print("Failed to perform action with recipient: \(error)")
           }
        }
        
    }

}
