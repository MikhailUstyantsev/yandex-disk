//
//  AssetExtractor.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 11.03.2023.
//

import UIKit

//It basically just gets image from assets, saves its data to disk and return file URL.
class AssetExtractor {
    
    static func createLocalUrl(forImageNamed name: String) -> URL? {

        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")

        guard fileManager.fileExists(atPath: url.path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
            else { return nil }

            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
            return url
        }

        return url
    }

}
