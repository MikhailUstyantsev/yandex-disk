//
//  LastUploadedCoordinator.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 12.03.2023.
//

import UIKit
import QuickLook

final class LastUploadedCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
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
    
    func showImageDetailViewController(with viewModeltoDisplay: LastUploadedCellViewModel) {
        let imageViewDetailViewController = ImageViewDetailViewController()
        let lastUploadedDetailViewModel = LastUploadedDetailViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        imageViewDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        navigationController.pushViewController(imageViewDetailViewController, animated: true)
    }
    
    func showWebViewDetailViewController(with viewModeltoDisplay: LastUploadedCellViewModel) {
        let webViewDetailViewController = WebViewDetailViewController()
        let lastUploadedDetailViewModel = LastUploadedDetailViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        webViewDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        navigationController.pushViewController(webViewDetailViewController, animated: true)
    }
    
    func showPDFViewDetailViewController(with viewModeltoDisplay: LastUploadedCellViewModel) {
        let pdfViewDetailViewController = PDFViewDetailViewController()
        let lastUploadedDetailViewModel = LastUploadedDetailViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        pdfViewDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        navigationController.pushViewController(pdfViewDetailViewController, animated: true)
    }
    
}
