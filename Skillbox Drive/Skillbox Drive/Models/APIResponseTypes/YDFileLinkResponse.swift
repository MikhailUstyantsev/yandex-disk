//
//  YDRenameResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 19.03.2023.
//

import Foundation

struct YDFileLinkResponse: Codable {
    let href: String
    let method: String
    let templated: Bool
}
