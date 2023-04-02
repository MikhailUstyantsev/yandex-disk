//
//  RMEndpoint.swift
//  RickAndMortyApp
//
//  Created by Mikhail Ustyantsev on 17.02.2023.
//

import Foundation

@frozen enum YDEndpoint: String {
    case lastUploaded = "resources/last-uploaded"
    case allFiles = "resources/files"
    case publicFiles = "resources/public"
    case download = "resources/download"
    case move = "resources/move"
    case publish = "resources/publish"
    case unpublish = "resources/unpublish"
    case resourcesOnly = "resources"
    case empty = ""
}
