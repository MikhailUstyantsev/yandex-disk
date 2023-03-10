//
//  YDRequest.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 08.03.2023.
//

import Foundation

final class YDRequest {
    
    struct Constants {
        static let baseUrl = "https://cloud-api.yandex.net/v1/disk/resources/"
    }
    
    let endpoint: YDEndpoint
    
    // Path components for API, if any
    private let pathComponents: [String]
    // Query arguments for API, if any
    private let queryParameters: [URLQueryItem]
    
    private var urlString: String {
        var string = Constants.baseUrl + endpoint.rawValue
        
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }
        
        if !queryParameters.isEmpty {
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    //    computed & constructed API url
    public var url: URL? {
        return URL(string: urlString)
    }
    //desired http method
    public let httpMethod = "GET"
    
    //construct request
    public init(endpoint: YDEndpoint,
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []) {
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
        self.endpoint = endpoint
    }
    
}

extension YDRequest {
    static let lastUploadedRequest = YDRequest(endpoint: .lastUploaded)
    static let getAllFilesRequest = YDRequest(endpoint: .allFiles)
    static let getPublicFilesRequest = YDRequest(endpoint: .publicFiles)
}

