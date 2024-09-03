//
//  MySubjectsUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 02.09.24.
//

extension Service {
    
    public func CallMySubjectsService(
        completion: @escaping(Result<[SubjectEntity], Error>) -> ()
    ){
        
        let url = URL(string: UrlStrings.mySubjectsUrl)!
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        
        // Set the necessary headers
        request.setValue("*/*", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Make the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    // Decode the response as an array of Subject models
                    let result = try decoder.decode(ApiSubjectResponse.self, from: data)
                    
                    // Convert Subject models to SubjectEntity
                    let entities = result.subjects.map {SubjectEntity(with: $0)}
                    
                    completion(.success(entities))
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
