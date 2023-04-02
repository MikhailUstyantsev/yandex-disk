//
//  YDGetPublicResourcesListResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 01.04.2023.
//

import Foundation


struct YDGetPublicResourcesListResponse: Codable {
    let items: [YDResource]
    let type: String?
    let limit: Int
    let offset: Int
    
}
