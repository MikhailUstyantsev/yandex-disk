//
//  LastUploadedCellViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 11.03.2023.
//

import Foundation

final class LastUploadedCellViewModel {
   
    let defaults = UserDefaults.standard
    
    var token: String = ""
    
    let name: String
    let date: String
    var size: Int64
    let preview: String
    let filePath: String
    
    var formattedDate: String {
        let createdDate = Date.createDateFromString(dateString: date)
        let dateToShowInCell = Date.createStringFromDate(date: createdDate)
        return dateToShowInCell
    }
    
    var sizeInMegaBytes: String {
        return "\(bytesToMegabytes(size)) MB"
    }
    
    var imageURL: URL {
        if let url = URL(string: preview) {
            return url
        } else {
            return AssetExtractor.createLocalUrl(forImageNamed: "file")!
        }
    }
    
    init(name: String, date: String, size: Int64, preview: String, filePath: String) {
        self.name = name
        self.date = date
        self.size = size
        self.preview = preview
        self.filePath = filePath
        self.token = defaults.object(forKey: "token") as? String ?? ""
    }
    
    
    //MARK: - Helper methods
    
    func bytesToMegabytes(_ bytes: Int64) -> Double {
        let megabytes = Double(bytes) / 1048576
        let roundedMegabytes = Double(round(100 * megabytes) / 100)
        return roundedMegabytes
    }
    
    
}
