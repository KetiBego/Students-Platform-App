//
//  DeleteUpVoteUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import Foundation

extension Service {
    
    // Function to call the delete upvote API
    public func callDeleteUpvoteService(fileId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        // Prepare the URL
        guard let url = URL(string: "http://localhost:8080/api/v1/files/upvotes") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Set headers
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        
        // Set the JSON body
        let requestBody: [String: Any] = ["fileId": fileId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(ServiceError.invalidBody))
            return
        }
        
        // Create the URLSession task
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle error
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for valid HTTP response
            if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                completion(.failure(ServiceError.responseError))
                return
            }
            
            // If no error, return success
            completion(.success(()))
        }
        
        // Start the task
        task.resume()
    }
}
