//
//  GetUserInfoUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 07.09.24.
//

import Foundation

extension Service {
    public func fetchCurrentUser(completion: @escaping (Result<UserInfoEntity, Error>) -> Void) {
        // API endpoint URL
        guard let url = URL(string: "http://localhost:8080/api/v1/user/me") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Get the auth token from UserDefaults
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                // Decode the API response to UserResponse
                let apiResponse = try JSONDecoder().decode(ApiUserInfo.self, from: data)
                
                // Map to the entity model
                let entityResponse = UserInfoEntity(with: apiResponse)
                
                // Return the mapped entity model
                completion(.success(entityResponse))
            } catch {
                completion(.failure(ServiceError.DecoderError))
            }
        }
        
        task.resume()
    }
}
