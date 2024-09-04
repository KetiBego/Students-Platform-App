//
//  FileUploadViewController.swift
//  Students-platform-app-ios
//
//  Created by Ruska Keldishvili on 04.09.24.
//

import UIKit
import UniformTypeIdentifiers
import Networking

class FileUploadViewController: UIViewController, UIDocumentPickerDelegate {
    
    let fileService = Service()
    
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
        // Example: Subject ID is hardcoded, replace with actual value
        let subjectId = 8
        
        fileService.callUploadFileService(subjectId: subjectId, fileURL: fileURL) { result in
            switch result {
            case .success:
                print("File uploaded successfully.")
            case .failure(let error):
                print("Failed to upload file: \(error)")
            }
        }
    }
}

