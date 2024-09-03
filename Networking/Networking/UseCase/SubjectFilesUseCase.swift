//
//  SubjectFilesUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 04.09.24.
//

import Foundation

extension Service {
    
    public func getSubjectFiles(subjectId: Int, completion: @escaping (Result<[MyFileEntity], Error>) -> Void) {
        
        let urlString = "http://localhost:8080/api/v1/files/subject/\(subjectId)"
        let url = URL(string: urlString)!
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("*/*", forHTTPHeaderField: "accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode < 300 else {
                completion(.failure(ServiceError.responseError))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let result = try decoder.decode([ApiMyFile].self, from: data)
                    
                    let entities = result.map { MyFileEntity(with: $0) }
                    
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
