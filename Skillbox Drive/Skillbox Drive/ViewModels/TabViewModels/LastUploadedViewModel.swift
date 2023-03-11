//
//  LastUploadedViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import Foundation

final class LastUploadedViewModel {
    
    var coordinator: Coordinator?
    
    var onUpdate: () -> Void = {}
    
    private var token: String = ""
    
    var cellViewModels: [LastUploadedCellViewModel] = []
    
    let request = YDRequest.lastUploadedRequest
    
    private(set) var files: [YDFile] = [] {
        didSet {
            for `file` in files where !cellViewModels.contains(where: { $0.name == file.name }) {
                let viewModel = LastUploadedCellViewModel(name: file.name!, date: file.created!, size: file.size ?? 0, preview: file.preview ?? "")
                cellViewModels.append(viewModel)
            }
        }
    }
    
    public func fetchFiles() {
        let request = YDRequest.lastUploadedRequest
        
        YDService.shared.execute(request, expecting: YDGetLastUploadedResponse.self) { result in
            switch result {
            case .success(let recievedItems):
                self.files = recievedItems.items ?? []
                self.onUpdate()
            case .failure(_):
                fatalError()
            }
        }
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        print("Cell tapped at row: \(indexPath.row+1)")
    }
    
    
}
