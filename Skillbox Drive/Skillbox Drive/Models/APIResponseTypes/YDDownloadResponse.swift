//
//  YDDownloadResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 13.03.2023.
//

import Foundation

struct YDDownloadResponse: Codable {
    let href: String
    let method: String
    let templated: Bool
}
