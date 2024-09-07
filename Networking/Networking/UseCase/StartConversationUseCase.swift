//
//  StartConversationUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

extension Service {
    public func startConversation(recipientUserId: Int, completion: @escaping (Result<ConversationStartResponseEntity, Error>) -> Void) {
        // API endpoint URL
        guard let url = URL(string: "http://localhost:8080/api/v1/conversations/start") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Get the auth token
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the JSON body
        let requestBody: [String: Any] = [
            "recipientUserId": recipientUserId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            // Perform the network request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(ServiceError.noData))
                    return
                }
                
                do {
                    // Decode the API response to ApiConversationStartResponse
                    let apiResponse = try JSONDecoder().decode(ApiConversationStartResponse.self, from: data)
                    
                    // Map to the entity model
                    let conversationEntity = ConversationStartResponseEntity(with: apiResponse)
                    
                    // Return the mapped entity model
                    completion(.success(conversationEntity))
                } catch {
                    completion(.failure(ServiceError.DecoderError))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(ServiceError.invalidBody))
        }
    }
}
