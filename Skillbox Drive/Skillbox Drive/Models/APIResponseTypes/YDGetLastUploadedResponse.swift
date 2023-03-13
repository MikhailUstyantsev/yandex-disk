//
//  YDGetLastUploadedResponse.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 08.03.2023.
//

import Foundation

struct YDGetLastUploadedResponse: Codable {
    let items: [YDFile]?
}


struct YDFile: Codable {
//имя файла
    let name: String?
//ссылка на превью
    let preview: String?
//размер
    let size: Int64?
//дата создания
    let created: String?
//дата изменения
    let modified: String?
//путь к файлу
    let path: String?
}
