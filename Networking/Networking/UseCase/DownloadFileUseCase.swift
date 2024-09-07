//
//  DownloadFileUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 04.09.24.
//

import Foundation

extension Service {
    
    public func downloadFile(withId fileId: Int, completion: @escaping (Result<URL, Error>) -> Void) {
        
        // Construct the URL using the provided file ID
        let url = URL(string: "http://localhost:8080/api/v1/files/download/\(fileId)")!
        
        // Retrieve the token from UserDefaults (or use other secure storage)
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        
        // Create a background session configuration to handle large downloads
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.downloadTask(with: request) { localURL, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let localURL = localURL,
                  let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode < 300 else {
                completion(.failure(ServiceError.responseError))
                return
            }
            
            // Successfully downloaded the file, return the local file URL
            completion(.success(localURL))
        }
        task.resume()
    }
}
