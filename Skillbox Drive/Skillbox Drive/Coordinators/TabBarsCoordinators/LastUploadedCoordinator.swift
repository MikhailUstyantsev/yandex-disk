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
    
    func showDetailViewController(with viewModeltoDisplay: LastUploadedCellViewModel) {
        let lastUploadedDetailViewController = LastUploadedDetailViewController()
        let lastUploadedDetailViewModel = LastUploadedDetailViewModel()
        lastUploadedDetailViewModel.cellViewModel = viewModeltoDisplay
        lastUploadedDetailViewController.viewModel = lastUploadedDetailViewModel
        lastUploadedDetailViewModel.coordinator = self
        navigationController.pushViewController(lastUploadedDetailViewController, animated: true)
    }
    
}
