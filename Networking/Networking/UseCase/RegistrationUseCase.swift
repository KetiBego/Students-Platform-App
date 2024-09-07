//
//  RegistrationUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 03.09.24.
//

extension Service {
    public func CallRegisterUserService(
        email: String,
        username: String,
        password: String,
        schoolId: Int,
        completion: @escaping (Result<Void, Error>) -> ()
    ) {
        let url = URL(string: UrlStrings.registerUrl)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Set the JSON body
        let body: [String: Any] = [
            "email": email,
            "username": username,
            "password": password,
            "schoolId": schoolId
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(ServiceError.invalidBody))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                completion(.success(()))
            } else {
                completion(.failure(ServiceError.responseError))
            }
        }
        task.resume()
    }
}
