//
//  YDGetLastUploadedResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 08.03.2023.
//

import Foundation

struct YDGetLastUploadedResponse: Codable {
    let items: [YDResource]
    let limit: Int
}
