////
////  FilesPageViewController.swift
////  Students-platform-app-ios
////
////  Created by Ruska Keldishvili on 04.09.24.

import MyAssetBook
import UIKit
import Networking
import PDFKit
import QuickLook // For previewing PDFs and other documents

class MyFilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CustomNavigatable {
    
    private var files: [MyFileEntity] = []
    private var downloadedFiles: [URL] = []
    private let tableView = UITableView()
    private let service = Service()
    
    private let refreshControl = UIRefreshControl()
    
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
                // Handle error (e.g., show an alert)
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
        
        cell.hideButton()
        
        return cell
    }
    
    private func handleDeleteButtonTapped(for file: MyFileEntity) {
        // Create the alert controller
        let alertController = UIAlertController(title: "წაშლა",
                                                message: "დარწმუნებული ხარ რომ ფაილის წაშლა გინდა?",
                                                preferredStyle: .alert)
        
        // Add the "Delete" action
        let deleteAction = UIAlertAction(title: "წაშლა", style: .destructive) { _ in
            // Perform the deletion if user confirms
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
        
        // Add the "Cancel" action
        let cancelAction = UIAlertAction(title: "გაუქმება", style: .cancel, handler: nil)
        
        // Add the actions to the alert controller
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
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
    
    
    @objc func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
           if gesture.state == .began {
               let location = gesture.location(in: self.tableView)
               if let indexPath = self.tableView.indexPathForRow(at: location) {
                   let file = files[indexPath.row]
                   self.handleDeleteButtonTapped(for: file)
               }
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
    
    // MARK: - Helper Methods
    
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

extension MyFilesViewController {
    var navTitle: NavigationTitle {
        .init(text: "ჩემი ფაილები", color: Color.Blue1)
    }
}
