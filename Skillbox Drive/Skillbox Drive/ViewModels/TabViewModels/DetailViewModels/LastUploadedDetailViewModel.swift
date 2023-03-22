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
    
    var onRenameUpdate: (YDFileLinkResponse) -> Void = { _ in }
    
    var onDeleteUpdate: (YDFileLinkResponse) -> Void = { _ in }
    
    let defaults = UserDefaults.standard
    
    private var token: String = ""
    
    public func downloadFile(completion: @escaping (YDFileLinkResponse)->Void) {
        let request = YDRequest(endpoint: .download, httpMethod: "GET", pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(cellViewModel?.filePath ?? "")")])
        
        YDService.shared.execute(request, expecting: YDFileLinkResponse.self) { result in
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
    
    //MARK: Rename file
    
    func renameFile(_ newName: String) {
        guard let previousFileName = cellViewModel?.name else { return }
        guard let previousFilePath = cellViewModel?.filePath else { return }
        let newFilePath = previousFilePath.replacingOccurrences(of: previousFileName, with: newName)
        
        let request = YDRequest(endpoint: .move, httpMethod: "POST", pathComponents: [], queryParameters: [
            URLQueryItem(name: "from", value: "\(cellViewModel?.filePath ?? "")"),
            URLQueryItem(name: "path", value: "\(newFilePath)")
        ])
        
        YDService.shared.execute(request, expecting: YDFileLinkResponse.self) { result in
            switch result {
            case .success(let renameResponse):
                self.onRenameUpdate(renameResponse)
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    //MARK: Get file's meta data
    
    func getFileMetaData(_ urlString: String, completion: @escaping (YDFileMetaDataResponse)->Void) {
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
    
    //MARK: Delete file
    
    //  тело ответа мы получаем только для непустой папки - если просиходит удаление файла или пустой папки, то API отвечает кодом 204 No content (ресурс успешно удален) без тела ответа.
    
    func deleteFile() {
        guard let filePath = cellViewModel?.filePath else { return }
        let request = YDRequest(endpoint: .emptyEndpoint, httpMethod: "DELETE", pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(filePath)")])
        YDService.shared.deleteFile(request, expecting: YDFileLinkResponse.self) { result in
            switch result {
            case .success(let success):
                self.onDeleteUpdate(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    deinit {
        print("deinit from LastUploadedDetailViewModel")
    }
}


