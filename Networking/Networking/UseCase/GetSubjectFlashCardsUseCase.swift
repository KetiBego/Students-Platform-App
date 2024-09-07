//
//  GetSubjectFlashCardsUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 06.09.24.
//

import Foundation

extension Service {
    
    // Function to fetch flashcard packs by subject ID
    public func fetchFlashcardPacks(for subjectId: Int, completion: @escaping (Result<[FlashcardPack], Error>) -> Void) {
        
        // API endpoint URL
        guard let url = URL(string: "http://localhost:8080/api/v1/flashcard/packs/subject/\(subjectId)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Get the auth token
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    // Decode the response into an array of FlashcardPack models
                    let result = try decoder.decode([ApiFlashcardPack].self, from: data)
                    let flashcardPacks = result.map { FlashcardPack(with: $0) }

                    completion(.success(flashcardPacks))
                } catch {
                    completion(.failure(ServiceError.DecoderError))
                }
            } else {
                completion(.failure(ServiceError.noData))
            }
        }
        
        task.resume()
    }
}

