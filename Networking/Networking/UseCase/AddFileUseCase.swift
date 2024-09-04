//
//  AddFileUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 04.09.24.
//


import Foundation
import UniformTypeIdentifiers

extension Service {
    public func callUploadFileService(
        subjectId: Int,
        fileURL: URL,
        completion: @escaping (Result<Void, Error>) -> ()
    ) {
        // Construct the URL with the subject ID query parameter
        guard let url = URL(string: "http://localhost:8080/api/v1/files/upload?subjectId=\(subjectId)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Retrieve the token from UserDefaults
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the necessary headers
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create the multipart form data
        let httpBody = createMultipartBody(fileURL: fileURL, boundary: boundary)
        request.httpBody = httpBody
        
        // Make the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 {
                completion(.success(()))
            } else {
                completion(.failure(ServiceError.responseError))
            }
        }
        task.resume()
    }
    
    private func createMultipartBody(fileURL: URL, boundary: String) -> Data {
        var body = Data()
        
        let fileName = fileURL.lastPathComponent
        let mimeType = mimeType(for: fileURL)
        
        // Add the file data to the request body
        if let fileData = try? Data(contentsOf: fileURL) {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
            body.append("Content-Type: \(mimeType)\r\n\r\n")
            body.append(fileData)
            body.append("\r\n")
        }
        
        // Close the boundary
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
    private func mimeType(for url: URL) -> String {
        if let utType = UTType(filenameExtension: url.pathExtension) {
            return utType.preferredMIMEType ?? "application/octet-stream"
        }
        return "application/octet-stream"
    }
}


// Data extension to append strings to Data objects
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
