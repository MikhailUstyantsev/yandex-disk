//
//  UserProfileCoordinator.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 27.03.2023.
//

import UIKit

final class UserProfileCoordinator: Coordinator {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    
    private var modalNavigationController: UINavigationController?
    
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType { .userProfileTab }
    
    
    func start() {
        let userProfileViewController = UserProfileViewController()
        let userProfileViewModel = UserProfileViewModel()
        userProfileViewController.viewModel = userProfileViewModel
        userProfileViewModel.coordinator = self
        navigationController.pushViewController(userProfileViewController, animated: true)
    }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
}
