//
//  SubjectFilesViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 04.09.24.
//

import MyAssetBook
import UIKit
import Networking
import PDFKit
import QuickLook // For previewing PDFs and other documents

class SubjectFilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomNavigatable, UIDocumentPickerDelegate {
    
    private var files: [MyFileEntity] = []
    private var downloadedFiles: [URL] = []
    private let tableView = UITableView()
    private let service = Service()
    private let subjectId: Int?
    private let subjectName: String?

    
    private let refreshControl = UIRefreshControl()
    
    private lazy var practiceButton: PrimaryButton = {
        let button = PrimaryButton()
        button.backgroundColor = Color.Yellow2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configure(with: .init(
            titleModel: .init(
                text: "გაივარჯიშე",
                color: Color.Blue3,
                font: .systemFont(ofSize: .XL)),
            action: { [weak self] in
                self?.navigateToFlashcards()
            }))
        button.layer.cornerRadius = .M
        return button
    }()
    
    private lazy var myfilesLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = Color.Blue3
        view.font = .systemFont(ofSize: .L, weight: .bold)
        view.text = "ფაილები"
        return view
    }()
    
    
    init(subjectId: Int, subjectName: String) {
        self.subjectId = subjectId
        self.subjectName = subjectName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        view.backgroundColor = Color.background
        fetchFiles()
        configureNavigationBar()
        navigationItem.hidesBackButton = true
    }
    
    private func setUp() {
        setupTableView()
        addSubviews()
        addConstraints()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(practiceButton) 
        view.addSubview(myfilesLabel)
    }
    
    private func addConstraints() {
        
        NSLayoutConstraint.activate([
            practiceButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        ])
        
        myfilesLabel.relativeTop(toView: practiceButton, constant: .XL2)
        myfilesLabel.left(toView: view, constant: .XL3)
        
        practiceButton.left(toView: view, constant: .XL3)
        practiceButton.right(toView: view, constant: .XL3)
        tableView.relativeTop(toView: myfilesLabel, constant: .M)
        tableView.left(toView: view, constant: .XL2)
        tableView.right(toView: view, constant: .XL2)
        tableView.bottom(toView: view)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundView?.backgroundColor = Color.background
        tableView.backgroundColor = Color.background
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(FileTableViewCell.self, forCellReuseIdentifier: "FileCell")
        refreshControl.addTarget(self, action: #selector(refreshFilesData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshFilesData() {
        fetchFiles()
    }
    
    private func fetchFiles() {
        service.getSubjectFiles(subjectId: subjectId!) { [weak self] result in
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
        
        if file.isUpvoted! {
            cell.upVoteButtonTapped = { [weak self] in
                self?.handleDownVote(for: file.id!)
            }
        }
        else {
            cell.upVoteButtonTapped = { [weak self] in
                self?.handleUpvoteCount(for: file.id!)
            }
            cell.downVote()
        }
        
        return cell
    }
    
    private func handleUpvoteCount(for fileId: Int) {
        service.addUpvoteToFile(fileId: fileId) { result in
            switch result {
            case .success:
                print("Upvote successfully added.")
            case .failure(let error):
                print("Failed to add upvote: \(error.localizedDescription)")
            }
        }
    }
    
    private func handleDownVote(for fileId: Int) {
        service.callDeleteUpvoteService(fileId: fileId) { result in
            switch result {
            case .success:
                print("Successfully deleted upvote")
            case .failure(let error):
                print("Failed to delete upvote: \(error)")
            }
        }
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
                    let imageViewController = PDFDisplayViewController(fileUrl: fileURL)
                    self?.present(imageViewController, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Failed to download file: \(error)")
            }
        }
    }
    
    private func navigateToFlashcards() {
        let flashcardsVC = FlashcardsViewController()
        flashcardsVC.setSubject(subjectId: subjectId!)
        navigationController?.pushViewController(flashcardsVC, animated: true)
    }
}

extension SubjectFilesViewController {
    var navTitle: NavigationTitle {
        .init(text: "\(subjectName!)", color: Color.Blue1)
    }
    
    var rightBarItems: [UIBarButtonItem]? {
        let button = AddBarButtonItem()
        button.addButtonTappedAction = { [weak self] in
            self?.presentDocumentPicker()
        }
        return [button]
    }
}

extension SubjectFilesViewController {
    func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.content])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            print("No file selected.")
            return
        }
        uploadFile(fileURL: selectedFileURL)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Document picker was cancelled.")
    }

    func uploadFile(fileURL: URL) {
        service.callUploadFileService(subjectId: subjectId!, fileURL: fileURL) { result in
            switch result {
            case .success:
                print("File uploaded successfully.")
            case .failure(let error):
                print("Failed to upload file: \(error)")
            }
        }
    }
}
