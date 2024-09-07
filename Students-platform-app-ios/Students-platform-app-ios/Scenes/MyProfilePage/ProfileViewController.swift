//
//  ProfileViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 07.09.24.
//


import UIKit
import MyAssetBook
import Networking
import PDFKit
import QuickLook

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomNavigatable {
    
    private let service = Service()
    
    private var username: String?
    private var email: String?
    private var files: [MyFileEntity] = []
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = Color.Blue1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = Color.Blue1
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.backgroundColor = Color.background
        fetchCurrentUser()
        fetchFiles()
        configureNavigationBar()
        navigationItem.hidesBackButton = true
    }
    
    private func setUp() {
        setupSubviews()
        setupConstraints()
        setupTableView()
    }
    
    private func setupSubviews() {
        view.addSubview(usernameLabel)
        view.addSubview(emailLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Username label constraints
            usernameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Email label constraints
            emailLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8),
            emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // TableView constraints
            tableView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FileTableViewCell.self, forCellReuseIdentifier: "FileCell")
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        fetchCurrentUser()
        fetchFiles()
    }
    
    private func fetchCurrentUser() {
        service.fetchCurrentUser { [weak self] result in
            switch result {
            case .success(let userEntity):
                self?.username = userEntity.displayName
                self?.email = userEntity.username
                DispatchQueue.main.async {
                    self?.usernameLabel.text = self?.username
                    self?.emailLabel.text = self?.email
                }
            case .failure(let error):
                print("Failed to fetch user: \(error)")
            }
        }
    }
    
    private func fetchFiles() {
        service.getUserFiles { [weak self] result in
            switch result {
            case .success(let files):
                self?.files = files
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
                print("Failed to fetch files: \(error)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return files.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FileCell", for: indexPath) as? FileTableViewCell else {
            return UITableViewCell()
        }
        
        let file = files[indexPath.row]
        cell.configure(with: file)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        cell.addGestureRecognizer(longPressGesture)
        
        
        return cell
    }
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let location = gesture.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: location) {
                let file = files[indexPath.row]
                handleDeleteButtonTapped(for: file)
            }
        }
    }
    
    private func handleDeleteButtonTapped(for file: MyFileEntity) {
        let alertController = UIAlertController(title: "წაშლა", message: "დარწმუნებული ხარ რომ ფაილის წაშლა გინდა?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "წაშლა", style: .destructive) { _ in
            self.service.callDeleteFileService(fileId: file.id!) { result in
                switch result {
                case .success:
                    DispatchQueue.main.async {
                        if let index = self.files.firstIndex(where: { $0.id == file.id }) {
                            self.files.remove(at: index)
                            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        }
                    }
                case .failure(let error):
                    print("Failed to delete file: \(error)")
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "გაუქმება", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = files[indexPath.row]
        
        if let fileName = file.fileName, fileName.hasSuffix(".pdf") {
            previewPDF(for: file)
        } else if let fileName = file.fileName, fileName.hasSuffix(".jpg") || fileName.hasSuffix(".png") {
            previewImage(for: file)
        } else {
            print("Unsupported file type")
        }
    }
    
    private func previewImage(for file: MyFileEntity) {
        guard let fileId = file.id else { return }
        service.downloadFile(withId: fileId) { [weak self] result in
            switch result {
            case .success(let fileURL):
                DispatchQueue.main.async {
                    let imageViewController = ImageViewController(imageURL: fileURL)
                    self?.present(imageViewController, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Failed to download file: \(error)")
            }
        }
    }
    
    private func previewPDF(for file: MyFileEntity) {
        guard let fileId = file.id else { return }
        service.downloadFile(withId: fileId) { [weak self] result in
            switch result {
            case .success(let fileURL):
                DispatchQueue.main.async {
                    let pdfViewController = PDFDisplayViewController(fileUrl: fileURL)
                    self?.present(pdfViewController, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Failed to download file: \(error)")
            }
        }
    }
    
    // MARK: - CustomNavigatable
    
    var navTitle: NavigationTitle {
        return .init(text: "ჩემი პროფილი", color: Color.Blue1)
    }
    
    var rightBarItems: [UIBarButtonItem]? {
        let button = LogOutBarButtonItem()
        button.addButtonTappedAction = { [weak self] in
            DispatchQueue.main.async {
               UserDefaults.standard.set("", forKey: "authToken")
               
               let entryPage = EntryPage()
               
               let navigationController = UINavigationController(rootViewController: entryPage)
               navigationController.modalPresentationStyle = .fullScreen
               
               self?.view.window?.rootViewController = navigationController
               self?.view.window?.makeKeyAndVisible()
           }
        }
        return [button]
    }
    
    
    var leftBarItems: [UIBarButtonItem]? { nil }
}
