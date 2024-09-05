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
    private let subjectId : Int?
    
    private let refreshControl = UIRefreshControl()
    
    init(subjectId: Int) {
        self.subjectId = subjectId
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
        AddSubviews()
        addConstraints()
    }
    
    private func AddSubviews() {
        view.addSubview(tableView)
    }
    
    private func addConstraints() {
        tableView.top(toView: view, constant: .XL2)
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
        service.getSubjectFiles(subjectId: subjectId!){ [weak self] result in
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
                // Handle success (e.g., update UI)
            case .failure(let error):
                print("Failed to delete upvote: \(error)")
                // Handle error (e.g., show an error message)
            }
        }

        
        
    }
    
     
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let file = files[indexPath.row]
        
        if let fileName = file.fileName, fileName.hasSuffix(".pdf") {
            // Handle PDF file preview
            previewPDF(for: file)
        } else if let fileName = file.fileName, fileName.hasSuffix(".jpg") || fileName.hasSuffix(".png") {
            // Handle image preview
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
    
    private func convertToPDF(from fileURL: URL) -> PDFDocument? {
        return PDFDocument(url: fileURL)
    }
    
    private func displayPDF(at url: URL) {
        let pdfView = PDFView(frame: self.view.bounds)
        pdfView.autoScales = true
        if let pdfDocument = PDFDocument(url: url) {
            pdfView.document = pdfDocument
            self.view.addSubview(pdfView)
        } else {
            print("Failed to load PDF")
        }
    }
}

extension SubjectFilesViewController {
    var navTitle: NavigationTitle {
        .init(text: "საგნის ფაილები", color: Color.Blue1)
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
        // Create a document picker for selecting any file type
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.content])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)
    }

    // Delegate method when the user selects a file
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            print("No file selected.")
            return
        }
        
        // Perform the file upload
        uploadFile(fileURL: selectedFileURL)
    }

    // Handle cancellation of document picker
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

