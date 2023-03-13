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
    
    public func downloadFile(completion: @escaping (YDDownloadResponse)->Void) {
        let request = YDRequest(endpoint: .download, pathComponents: [], queryParameters: [URLQueryItem(name: "path", value: "\(cellViewModel?.filePath ?? "")")])
        
        YDService.shared.execute(request, expecting: YDDownloadResponse.self) { result in
            switch result {
            case .success(let downloadResponse):
                completion(downloadResponse)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    deinit {
        print("deinit from LastUploadedDetailViewModel")
    }
}
