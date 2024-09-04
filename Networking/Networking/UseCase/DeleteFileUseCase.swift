//
//  DeleteFileUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 04.09.24.
//


extension Service {
    public func callDeleteFileService(
        fileId: Int,
        completion: @escaping (Result<Void, Error>) -> ()
    ) {
        // Construct the URL with the file ID
        guard let url = URL(string: "http://localhost:8080/api/v1/files/\(fileId)") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Retrieve the token from UserDefaults
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        // Set the necessary headers
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
}


