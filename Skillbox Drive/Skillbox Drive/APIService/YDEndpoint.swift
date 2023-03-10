//
//  RMEndpoint.swift
//  RickAndMortyApp
//
//  Created by Mikhail Ustyantsev on 17.02.2023.
//

import Foundation

@frozen enum YDEndpoint: String {
    case lastUploaded = "last-uploaded"
    case allFiles = "files"
    case publicFiles = "public"
}
