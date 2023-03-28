//
//  YDGetDiskDataResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 27.03.2023.
//

import Foundation


struct YDGetDiskDataResponse: Codable {
    
    let trashSize, totalSpace, usedSpace: Int
    let systemFolders: Folders
    
    enum CodingKeys: String, CodingKey {
        case trashSize = "trash_size"
        case totalSpace = "total_space"
        case usedSpace = "used_space"
        case systemFolders = "system_folders"
    }
    
    struct Folders: Codable {
        let applications, downloads: String
    }
    
}
