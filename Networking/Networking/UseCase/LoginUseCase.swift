//
//  LoginUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 27.08.24.
//

extension Service {
    
    public func CallLoginService(
        for email: String,
        password: String,
        completion: @escaping(Result<LoginEntity, Error>) -> ()
    ){

        let url = URL(string: UrlStrings.loginUrl)
            
        // Create a POST request
        guard let request = makeLoginRequest(with: url!, email: email, password: password) else {
            completion(.failure(ServiceError.invalidParameters))
            return
        }
        // Make the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode(ApiLoginModel.self, from: data)
                    completion(.success(.init(with: result)))
                } catch {
                    completion(.failure(ServiceError.DecoderError))
                }
            } else {
                completion(.failure(ServiceError.noData))
            }
        }
        task.resume()
    }
    
    
    func makeLoginRequest(with url : URL, email: String, password: String) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
            
        // Set the necessary headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("*/*", forHTTPHeaderField: "accept")
            
        // Parameters to be sent in the body
        let parameters = [
            "email": email,
            "password": password
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            return nil
        }
        
        return request
        
        
    }
}
