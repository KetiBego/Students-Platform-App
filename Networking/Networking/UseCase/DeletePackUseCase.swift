//
//  DeletePackUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//


extension Service {

    // Function to delete a flashcard pack
    func deleteFlashcardPack(flashcardPackId: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // API endpoint URL
        guard let url = URL(string: "http://localhost:8080/api/v1/flashcard/packs") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Get the auth token
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the JSON body
        let requestBody: [String: Any] = [
            "flashcardPackId": flashcardPackId
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            // Create the request
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpBody = jsonData
            
            // Perform the network request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 200 {
                    completion(.success(()))
                } else {
                    completion(.failure(ServiceError.responseError))
                }
            }
            
            task.resume()
        } catch {
            completion(.failure(ServiceError.noData))
        }
    }
}
