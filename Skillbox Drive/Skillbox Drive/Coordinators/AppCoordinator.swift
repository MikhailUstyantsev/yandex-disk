//
//  AppCoordinator.swift
//  CoordinatorWithTabBarController
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import UIKit

// Define what type of flows can be started from this Coordinator
protocol AppCoordinatorProtocol: Coordinator {
    func showLoginFlow()
    func showMainFlow()
}

// App coordinator is the only one coordinator which will exist during app's life cycle
class AppCoordinator: AppCoordinatorProtocol {
    weak var finishDelegate: CoordinatorFinishDelegate? = nil
    
    var navigationController: UINavigationController
    
    var childCoordinators = [Coordinator]()
    
    var type: CoordinatorType { .app }
        
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.setNavigationBarHidden(true, animated: true)
    }

    func start() {
        showLoginFlow()
    }
        
    func showLoginFlow() {
        // Implement Login FLow
        let loginCoordinator = LoginCoordinator(navigationController)
           loginCoordinator.finishDelegate = self
           loginCoordinator.start()
           childCoordinators.append(loginCoordinator)
    }
    
    func showMainFlow() {
        // Implement Main (Tab bar) FLow
        let tabCoordinator = TabCoordinator(navigationController)
            tabCoordinator.finishDelegate = self
            tabCoordinator.start()
            childCoordinators.append(tabCoordinator)
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
//        When the child Coordinator is about to be deallocated we can check the type of its flow and decide what should be shown next. If it was Login show Main (TabBarController) flow and vice versa. The logic here can vary on the purpose of your app.
        
        switch childCoordinator.type {
               case .tab:
                   navigationController.viewControllers.removeAll()

                   showLoginFlow()
               case .login:
                   navigationController.viewControllers.removeAll()

                   showMainFlow()
               default:
                   break
               }
        
    }
}
