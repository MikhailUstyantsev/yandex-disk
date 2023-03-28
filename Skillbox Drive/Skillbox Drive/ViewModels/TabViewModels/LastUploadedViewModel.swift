//
//  LastUploadedViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import Foundation

final class LastUploadedViewModel {
    
    var coordinator: LastUploadedCoordinator?
    
    var isLoadingMoreData = false
    
    var onUpdate: () -> Void = {}
    
    var refreshTableView: () -> Void = {}
    
    var cellViewModels: [TableViewCellViewModel] = []
    
    let request = YDRequest.lastUploadedRequest
    
    private(set) var files: [YDResource] = [] {
        didSet {
            for file in files where !cellViewModels.contains(where: { $0.name == file.name }) {
                let viewModel = TableViewCellViewModel(name: file.name , date: file.created , size: file.size ?? 0, preview: file.preview ?? "", filePath: file.path , mediaType: file.mimeType ?? "", directoryType: "")
                cellViewModels.append(viewModel)
            }
        }
    }
    
    public func fetchFiles() {
        let request = YDRequest.lastUploadedRequest
        
        YDService.shared.execute(request, expecting: YDGetLastUploadedResponse.self) { result in
            switch result {
            case .success(let recievedItems):
                self.files = recievedItems.items 
                self.onUpdate()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchAdditionalFiles() {
        guard !isLoadingMoreData else {
            return
        }
        isLoadingMoreData = true
        print("Fetching more files")
        //create additional request
//        в блоке success меняем флаг на false
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.isLoadingMoreData = false            
        }
    }
    
    func didSelectRow(with viewModel: TableViewCellViewModel, fileType: String) {
        switch fileType.lowercased() {
        case _ where fileType.localizedStandardContains("image"):
            coordinator?.showImageDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("xml"):
            coordinator?.showWebViewDetailViewController(with: viewModel)
        case _ where fileType.localizedStandardContains("pdf"):
            coordinator?.showPDFViewDetailViewController(with: viewModel)
        default: coordinator?.showUnknowDetailViewController(with: viewModel)
        }
    }
    
    
    func reFetchData() {
        fetchFiles()
        refreshTableView()
    }
    
    deinit {
        print("Deinit from LastUploadedViewModel")
    }
    
}
