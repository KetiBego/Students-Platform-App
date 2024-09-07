//
//  GetConversationsUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

extension Service {
    public func fetchUserConversations(completion: @escaping (Result<ConversationResponseEntity, Error>) -> Void) {
        // API endpoint URL
        guard let url = URL(string: "http://localhost:8080/api/v1/conversations/user") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Get the auth token
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                // Decode the API response to ConversationResponse
                let apiResponse = try JSONDecoder().decode(ConversationResponse.self, from: data)
                
                // Map to the entity model
                let entityResponse = ConversationResponseEntity(with: apiResponse)
                
                // Return the mapped entity model
                completion(.success(entityResponse))
            } catch {
                completion(.failure(ServiceError.DecoderError))
            }
        }
        
        task.resume()
    }
}
