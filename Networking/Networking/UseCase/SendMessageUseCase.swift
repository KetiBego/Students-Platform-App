//
//  SendMessageUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import Foundation

import Foundation

extension Service {
    public func sendMessage(
        conversationId: Int,
        message: String,
        completion: @escaping (Result<Void, Error>) -> ()
    ) {
        // Construct the URL
        guard let url = URL(string: "http://localhost:8080/api/v1/messages/send") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Retrieve the token from UserDefaults
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the necessary headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Create the JSON body
        let requestBody: [String: Any] = [
            "conversationId": conversationId,
            "message": message
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completion(.failure(ServiceError.DecoderError))
            return
        }
        
        // Make the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 {
                // If the status code is in the 200 range, treat it as success
                completion(.success(()))
            } else {
                // Handle unsuccessful status codes
                completion(.failure(ServiceError.responseError))
            }
        }
        task.resume()
    }
}
