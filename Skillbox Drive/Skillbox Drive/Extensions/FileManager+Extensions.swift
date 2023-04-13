//
//  FileManager+Extensions.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 13.04.2023.
//

import Foundation

extension FileManager {
    
    /// Remove all files and caches from directory.
    public static func removeAllFilesDirectory() {
        let fileManager = FileManager()
        let mainPaths = [
            FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).map(\.path)[0],
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).map(\.path)[0]
        ]
        mainPaths.forEach { mainPath in
            do {
                let content = try fileManager.contentsOfDirectory(atPath: mainPath)
                content.forEach { file in
                    do {
                        try fileManager.removeItem(atPath: URL(fileURLWithPath: mainPath).appendingPathComponent(file).path)
                    } catch {
                        // Crashlytics.crashlytics().record(error: error)
                    }
                }
            } catch {
                // Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}
