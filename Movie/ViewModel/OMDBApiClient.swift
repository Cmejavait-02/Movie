//
//  OMDBApiClient.swift
//  Movie
//
//  Created by Bishwajit Yadav on 26/08/24.
//

import Foundation

class OMDBApiClient {
    static let shared = OMDBApiClient()
    
    private let apiKey: String
    private let baseURL: String
    
    private init(apiKey: String = "43939159", baseURL: String = "http://www.omdbapi.com/") {
        self.apiKey = apiKey
        self.baseURL = baseURL
    }
    
    func fetch<T: Codable>(parameters: [String: String], responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        var urlComponents = URLComponents(string: baseURL)!
        
        // Add the API key as a query item
        var queryItems = [URLQueryItem(name: "apikey", value: apiKey)]
        
        // Add other parameters as query items
        for (key, value) in parameters {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let decodingError {
                completion(.failure(decodingError))
            }
        }.resume()
    }
}

