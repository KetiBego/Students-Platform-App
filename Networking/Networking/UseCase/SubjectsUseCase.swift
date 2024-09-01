//
//  SubjectsUseCase.swift
//  Networking
//
//  Created by Ruska Keldishvili on 01.09.24.
//

extension Service {
    
    public func CallSubjectsService(
        completion: @escaping(Result<[SubjectEntity], Error>) -> ()
    ){
        
        let url = URL(string: UrlStrings.subjectsUrl)!
        
        let token = "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJydXNrYUBmcmVldW5pLmVkdS5nZSIsImlhdCI6MTcyNTE5OTM4NCwiZXhwIjoxNzI1ODA3ODg0fQ.xi1e7wcOraWuJ-d3hqQt_arKRiHTvSumqrTKuF4-vTP7RsTm6OcPhHZpXKZaUi1dLwluJEPo2q6bhlz2VaNkEw"
        
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
