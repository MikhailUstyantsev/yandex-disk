//
//  YDService.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 08.03.2023.
//

import Foundation
//основной сервис для получения YandexDisk данных

final class YDService {
    static let shared = YDService()
    
    private init() { }
    
    enum YDServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    
    public func execute<T: Codable>(
        _ request: YDRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            guard let urlRequest = self.authorizedRequest(from: request) else {
                completion(.failure(YDServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? YDServiceError.failedToGetData))
                    return
                }
                // decode response
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    
    private func authorizedRequest(from ydRequest: YDRequest) -> URLRequest? {
            let token = KeychainManager.shared.getTokenFromKeychain() ?? ""
            guard let url = ydRequest.url else { return nil }
            var request = URLRequest(url: url)
            //request.httpMethod = request.httpMethod
            request.httpMethod = ydRequest.httpMethod
            request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    public func getData<T: Codable>(
        _ request: URLRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? YDServiceError.failedToGetData))
                    return
                }
                // decode response
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    
    public func deleteFile<T: Codable>(
        _ request: YDRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void) {
            guard let urlRequest = self.authorizedRequest(from: request) else {
                completion(.failure(YDServiceError.failedToCreateRequest))
                return
            }
            let mockData = YDFileLinkResponse(href: "", method: "", templated: false)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    if let response = response as? HTTPURLResponse, response.statusCode == 204 {
                        completion(.success(mockData as! T))
                        return
                    }
                    guard let data = data else {
                        completion(.failure(error ?? YDServiceError.failedToGetData))
                        return
                    }
                do {
                    let result = try JSONDecoder().decode(type.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    
    
    
}
