//
//  LastUploadedCoordinator.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 12.03.2023.
//

import UIKit

final class LastUploadedCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    private var modalNavigationController: UINavigationController?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .lastUploadedTab }
    
    
    func start() {
        let lastUploadedVC = LastUploadedViewController()
        let lastUploadedViewModel = LastUploadedViewModel()
        lastUploadedVC.viewModel = lastUploadedViewModel
        lastUploadedViewModel.coordinator = self
        navigationController.pushViewController(lastUploadedVC, animated: true)
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: Navigate to WebViewViewController
    
    func showWebViewDetailViewController(with viewModeltoDisplay: LastUploadedCellViewModel) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
        
        let webViewDetailViewController = WebViewDetailViewController()
        
        modalNavigationController?.setViewControllers([webViewDetailViewController], animated: false)
        
        let lastUploadedDetailViewModel = LastUploadedDetailViewModel()
        
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        webViewDetailViewController.viewModel = lastUploadedDetailViewModel
        
        lastUploadedDetailViewModel.coordinator = self
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
//        navigationController.pushViewController(webViewDetailViewController, animated: true)
    }
    
    //MARK: Navigate to ImageViewViewController
    
    func showImageDetailViewController(with viewModeltoDisplay: LastUploadedCellViewModel) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
      
        let imageViewDetailViewController =
        ImageViewDetailViewController()
        
        let lastUploadedDetailViewModel = LastUploadedDetailViewModel()
        
        
        modalNavigationController?.setViewControllers([imageViewDetailViewController], animated: false)
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        
        imageViewDetailViewController.viewModel = lastUploadedDetailViewModel
        
        lastUploadedDetailViewModel.coordinator = self
        
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
//        navigationController.pushViewController(imageViewDetailViewController, animated: true)
    }
    
    //MARK: Navigate to PDFViewViewController
    
    func showPDFViewDetailViewController(with viewModeltoDisplay: LastUploadedCellViewModel) {
        self.modalNavigationController = UINavigationController()
        modalNavigationController?.modalTransitionStyle = .flipHorizontal
        modalNavigationController?.modalPresentationStyle = .fullScreen
        let pdfViewDetailViewController = PDFViewDetailViewController()
        modalNavigationController?.setViewControllers([pdfViewDetailViewController], animated: false)
        let lastUploadedDetailViewModel = LastUploadedDetailViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        pdfViewDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        if let modalNavigationController = modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
        
//        navigationController.pushViewController(pdfViewDetailViewController, animated: true)
    }
    
    //MARK: Navigate to UnknownViewController
    
    func showUnknowDetailViewController(with viewModeltoDisplay: LastUploadedCellViewModel) {
        let unknownDetailViewController = UnknownDetailViewController()
        let lastUploadedDetailViewModel = LastUploadedDetailViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        unknownDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        navigationController.pushViewController(unknownDetailViewController, animated: true)
    }
    
}
