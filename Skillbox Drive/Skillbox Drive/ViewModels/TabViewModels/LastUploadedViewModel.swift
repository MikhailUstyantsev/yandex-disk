//
//  LastUploadedViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import Foundation

final class LastUploadedViewModel {
    
    var coordinator: LastUploadedCoordinator?
    
    var onUpdate: () -> Void = {}
    
    var refreshTableView: () -> Void = {}
    
    var cellViewModels: [LastUploadedCellViewModel] = []
    
    let request = YDRequest.lastUploadedRequest
    
    private(set) var files: [YDFile] = [] {
        didSet {
            for file in files where !cellViewModels.contains(where: { $0.name == file.name }) {
                let viewModel = LastUploadedCellViewModel(name: file.name ?? "", date: file.created ?? "", size: file.size ?? 0, preview: file.preview ?? "", filePath: file.path ?? "")
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
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func didSelectRow(with viewModel: LastUploadedCellViewModel) {
        print("Path to file: \(viewModel.filePath)")
        coordinator?.showDetailViewController(with: viewModel)
    }
    
    func reFetchData() {
        fetchFiles()
        refreshTableView()
    }
}
