//
//  DiskResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 23.09.2022.
//

import Foundation

struct YDGetAllFilesResponse: Codable {
    let items: [DiskFile]?
    let limit: Int
    let offset: Int
}


struct DiskFile: Codable {
    let name: String
    let preview: String
    let created, modified: String
    let path, md5, type, mimeType: String
    let size: Int64
    
    enum CodingKeys: String, CodingKey {
        case name, preview, created, modified, path, md5, type
        case mimeType = "mime_type"
        case size
    }
}
