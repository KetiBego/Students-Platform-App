////
////  FilesPageViewController.swift
////  Students-platform-app-ios
////
////  Created by Ruska Keldishvili on 04.09.24.
////
//
//import Networking
//
////class FilesPageViewController: UIViewController {
////    
////    let service = Service()
////    let subjectId = 44
////    
////    // MARK: - Lifecycle Methods
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        setUpUI()
////        
//////        service.getSubjectFiles(subjectId: subjectId) { result in
//////            switch result {
//////            case .success(let files):
//////                // Process the files, which are instances of MyFileEntity
//////                for file in files {
//////                    print("File: \(file.fileName ?? "Unknown")")
//////                }
//////            case .failure(let error):
//////                print("Error retrieving subject files: \(error)")
//////            }
//////        }
////        
////        service.getUserFiles() { result in
////            switch result {
////            case .success(let files):
////                // Process the files, which are instances of MyFileEntity
////                for file in files {
////                    print("File: \(file.fileName ?? "Unknown")")
////                }
////            case .failure(let error):
////                print("Error retrieving subject files: \(error)")
////            }
////        }
////    }
////    
////    
////   
////    
////    override func viewWillAppear(_ animated: Bool) {
////        super.viewWillAppear(animated)
////        // Add any additional setup before the view appears
////    }
////    
////    override func viewDidLayoutSubviews() {
////        super.viewDidLayoutSubviews()
////        // Add any layout adjustments after the subviews have been laid out
////    }
////    
////    // MARK: - Setup UI
////    
////    private func setUpUI() {
////        // Set up the user interface components here
////        view.backgroundColor = .white  // Set background color to white
////    }
////}
//
//
//
////import UIKit
////
////class FileDisplayViewController: UIViewController {
////    
////    var downloadedImage: UIImageView!
////    let service = Service()
////    
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        setupUI()
////        downloadAndDisplayImage()
////    }
////    
////    private func setupUI() {
////        view.backgroundColor = .white
////        
////        downloadedImage = UIImageView()
////        downloadedImage.translatesAutoresizingMaskIntoConstraints = false
////        downloadedImage.contentMode = .scaleAspectFit
////        view.addSubview(downloadedImage)
////        
////        // Set constraints
////        NSLayoutConstraint.activate([
////            downloadedImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
////            downloadedImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
////            downloadedImage.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
////            downloadedImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6)
////        ])
////    }
////    
////    private func downloadAndDisplayImage() {
////        // Assuming Service class is already initialized as 'service'
////        service.downloadFile(withId: 2) { [weak self] result in
////            switch result {
////            case .success(let fileURL):
////                DispatchQueue.main.async {
////                    if let data = try? Data(contentsOf: fileURL),
////                       let image = UIImage(data: data) {
////                        self?.downloadedImage.image = image
////                    } else {
////                        // Handle error, e.g. show an alert
////                    }
////                }
////            case .failure(let error):
////                print("Error downloading file: \(error)")
////                // Handle error, e.g. show an alert
////            }
////        }
////    }
////}
//
//
//
//import UIKit
//import PDFKit
//
//class PDFDisplayViewController: UIViewController {
//    
//    var pdfView: PDFView!
//    let service = Service()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        downloadAndDisplayPDF()
//    }
//    
//    private func setupUI() {
//        view.backgroundColor = .white
//        
//        // Initialize and configure PDFView
//        pdfView = PDFView(frame: view.bounds)
//        pdfView.autoScales = true
//        pdfView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(pdfView)
//        
//        // Set constraints
//        NSLayoutConstraint.activate([
//            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
//            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func downloadAndDisplayPDF() {
//        // Assuming Service class is already initialized as 'service'
//        service.downloadFile(withId: 3) { [weak self] result in
//            switch result {
//            case .success(let fileURL):
//                DispatchQueue.main.async {
//                    if let pdfDocument = PDFDocument(url: fileURL) {
//                        self?.pdfView.document = pdfDocument
//                    } else {
//                        // Handle error, e.g., show an alert
//                        print("Failed to load PDF document")
//                    }
//                }
//            case .failure(let error):
//                print("Error downloading file: \(error)")
//                // Handle error, e.g., show an alert
//            }
//        }
//    }
//}


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
        
        cell.deleteButtonTapped = { [weak self] in
            self?.handleDeleteButtonTapped(for: file)
        }
        return cell
    }
    
    private func handleDeleteButtonTapped(for file: MyFileEntity) {
        
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
                print("Failed to delete subject: \(error)")
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
    
    // MARK: - File Handling
    
//    private func previewPDF(for file: MyFileEntity) {
//        guard let fileId = file.id else { return }
//        service.downloadFile(withId: fileId) { [weak self] result in
//            switch result {
//            case .success(let fileURL):
//                DispatchQueue.main.async {
//                    let previewController = QLPreviewController()
//                    self?.downloadedFiles = [fileURL]
//                    previewController.dataSource = self
//                    self?.present(previewController, animated: true, completion: nil)
//                }
//            case .failure(let error):
//                print("Failed to download file: \(error)")
//            }
//        }
//    }
    
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
    
//     MARK: - QLPreviewControllerDataSource
//    
//    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//        return 1
//    }
//    
//    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//        return convertToPDF(downloadedFiles[0] as QLPreviewItem
//    }
    
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



//
//var rightBarItems: [UIBarButtonItem]? {
//    let button = AddBarButtonItem()
//    button.addButtonTappedAction = { [weak self] in
//
//    }
//    return [button]
//}
