//
//  UpVotesUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 05.09.24.
//


extension Service {

    public func addUpvoteToFile(
        fileId: Int,
        completion: @escaping(Result<Void, Error>) -> ()
    ) {
        // Define the URL
        guard let url = URL(string: "http://localhost:8080/api/v1/files/upvotes/add") else {
            completion(.failure(ServiceError.invalidURL))
            return
        }
        
        // Retrieve the token from UserDefaults (you may need to adapt this)
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Set the necessary headers
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the body data
        let body: [String: Any] = ["fileId": fileId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(ServiceError.invalidBody))
            return
        }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Handle the response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 {
                completion(.success(()))
            } else {
                completion(.failure(ServiceError.responseError))
            }
        }
        
        task.resume()
    }
}

