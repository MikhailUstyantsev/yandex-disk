//
//  DiskResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 23.09.2022.
//

import Foundation

struct YDGetAllFilesResponse: Codable {
    let items: [DiskFile]?
}


struct DiskFile: Codable {
//    имя файла
    let name: String?
//    ссылка на превью
    let preview: String?
//    размер
    let size: Int64?
}
