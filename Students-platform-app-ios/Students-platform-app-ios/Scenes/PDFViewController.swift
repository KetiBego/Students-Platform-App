//
//  PDFViewCOntroler.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 04.09.24.
//

import UIKit
import PDFKit
import Networking

class PDFDisplayViewController: UIViewController {

    var pdfView: PDFView!
    let service = Service()
    
    private let fileUrl: URL

    
    init(fileUrl: URL) {
        self.fileUrl = fileUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showPdf()
    }
    private func showPdf() {
        
        if let pdfDocument = PDFDocument(url: self.fileUrl) {
            self.pdfView.document = pdfDocument
        } else {
            // Handle error, e.g., show an alert
            print("Failed to load PDF document")
        }
        
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Initialize and configure PDFView
        pdfView = PDFView(frame: view.bounds)
        pdfView.autoScales = true
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)

        // Set constraints
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func downloadAndDisplayPDF() {
        // Assuming Service class is already initialized as 'service'
        service.downloadFile(withId: 3) { [weak self] result in
            switch result {
            case .success(let fileURL):
                DispatchQueue.main.async {
                    if let pdfDocument = PDFDocument(url: fileURL) {
                        self?.pdfView.document = pdfDocument
                    } else {
                        // Handle error, e.g., show an alert
                        print("Failed to load PDF document")
                    }
                }
            case .failure(let error):
                print("Error downloading file: \(error)")
                // Handle error, e.g., show an alert
            }
        }
    }
}
