//
//  AddSubjectUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 03.09.24.
//

extension Service {
    public func CallAddSubjectsService(
        subjectId: Int,
        completion: @escaping (Result<Void, Error>) -> ()
    ) {
        // Update the URL to the correct endpoint
        let url = URL(string: UrlStrings.addSubjects)!
         
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""


        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        // Set the necessary headers
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the JSON body
        let body: [String: Any] = ["subjectId": subjectId]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(ServiceError.invalidBody))
            return
        }
        
        // Make the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode <= 300 {
                completion(.success(()))
            } else {
                completion(.failure(ServiceError.responseError))
            }
        }
        task.resume()
    }
}
