//
//  YDFileMetaDataResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 19.03.2023.
//

import Foundation

// MARK: - MetaDataResponse
struct YDFileMetaDataResponse: Codable {
    let publicKey: String?
    let embedded: Embedded
    let name: String
    let created: String
//    let customProperties: CustomProperties
    let publicURL: String?
    let modified: String
    let path, type: String

    enum CodingKeys: String, CodingKey {
        case publicKey = "public_key"
        case embedded = "_embedded"
        case name, created
//        case customProperties = "custom_properties"
        case publicURL = "public_url"
        case modified, path, type
    }
}

// MARK: - CustomProperties
struct CustomProperties: Codable {
    let foo: String?
    let bar: String?
}

// MARK: - Embedded
struct Embedded: Codable {
    let sort, path: String?
    let items: [Item]
    let limit, offset: Int?
}

// MARK: - Item
struct Item: Codable {
    let name: String?
    let path, type: String
    let modified, created: String?
    let preview: String?
    let md5, mimeType: String?
    let size: Int64?

    enum CodingKeys: String, CodingKey {
        case path, type, name, modified, created, preview, md5
        case mimeType = "mime_type"
        case size
    }
}

