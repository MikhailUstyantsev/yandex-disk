//
//  LastUploadedDetailViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 13.03.2023.
//

import Foundation


final class LastUploadedDetailViewModel: NSObject {
    
    weak var coordinator: Coordinator?
    
    var cellViewModel: LastUploadedCellViewModel? 
    
    var onUpdate: (YDRenameResponse) -> Void = { _ in }
    
    let defaults = UserDefaults.standard
    
    private var token: String = ""
    
    public func downloadFile(completion: @escaping (YDDownloadResponse)->Void) {
        let request = YDRequest(endpoint: .download, httpMethod: "GET", pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(cellViewModel?.filePath ?? "")")])
        
        YDService.shared.execute(request, expecting: YDDownloadResponse.self) { result in
            switch result {
            case .success(let downloadResponse):
                completion(downloadResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func prepareSubtitle(subtitle: String) -> String {
        let date = Date.createDateFromString(dateString: subtitle)
        let stringFromDate = Date.createStringFromDate(date: date)
        return stringFromDate
    }
    
    func renameFile(_ newName: String) {
        guard let previousFileName = cellViewModel?.name else { return }
        guard let previousFilePath = cellViewModel?.filePath else { return }
        let newFilePath = previousFilePath.replacingOccurrences(of: previousFileName, with: newName)
        
        let request = YDRequest(endpoint: .move, httpMethod: "POST", pathComponents: [], queryParameters: [
            URLQueryItem(name: "from", value: "\(cellViewModel?.filePath ?? "")"),
            URLQueryItem(name: "path", value: "\(newFilePath)")
        ])
        
        YDService.shared.execute(request, expecting: YDRenameResponse.self) { result in
            switch result {
            case .success(let renameResponse):
                self.onUpdate(renameResponse)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getFileProperty(_ urlString: String, completion: @escaping (YDFileMetaDataResponse)->Void) {
        token = defaults.object(forKey: "token") as? String ?? ""
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
        YDService.shared.getData(request, expecting: YDFileMetaDataResponse.self) { result in
            switch result {
            case .success(let fileMetaDataResponse):
                completion(fileMetaDataResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func shareFile() {
        print("share file")
    }
    
    func deleteFile() {
        print("delete file")
    }
    
    deinit {
        print("deinit from LastUploadedDetailViewModel")
    }
}


