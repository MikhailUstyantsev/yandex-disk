//
//  TabCoordinator.swift
//  CoordinatorWithTabBarController
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import UIKit

//TabCoordinator prepares dependent ViewControllers, Tabs and initializes TabBarViewController. When “start()” function is called, it start all chain of action and runs the flow.

enum TabBarPage {
    case profile
    case lastUploaded
    case allFiles

    init?(index: Int) {
        switch index {
        case 0:
            self = .profile
        case 1:
            self = .lastUploaded
        case 2:
            self = .allFiles
        default:
            return nil
        }
    }
    
    func pageTitleValue() -> String {
        switch self {
        case .profile:
            return "Профиль"
        case .lastUploaded:
            return "Последние"
        case .allFiles:
            return "Все файлы"
        }
    }

    func pageOrderNumber() -> Int {
        switch self {
        case .profile:
            return 0
        case .lastUploaded:
            return 1
        case .allFiles :
            return 2
        }
    }

    // Add tab icon value
    
    func pageTabIcon() -> UIImage {
            switch self {
            case .profile:
                return UIImage(systemName: "person") ?? UIImage()
            case .lastUploaded:
                return UIImage(systemName: "doc") ?? UIImage()
            case .allFiles :
                return UIImage(systemName: "archivebox") ?? UIImage()
            }
    }
    
    // Add tab icon selected / deselected color
    
    // etc
}


protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    
    func setSelectedIndex(_ index: Int)
    
    func currentPage() -> TabBarPage?
}

final class TabCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
        
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    
    var tabBarController: UITabBarController

    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }

    func start() {
        // Let's define which pages do we want to add into tab bar
        let pages: [TabBarPage] = [.profile, .lastUploaded, .allFiles]
            .sorted(by: { $0.pageOrderNumber() < $1.pageOrderNumber() })
        
        // Initialization of ViewControllers or these pages
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        
        prepareTabBarController(withTabControllers: controllers)
    }
    
    deinit {
        print("TabCoordinator deinit")
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        /// Set delegate for UITabBarController
        tabBarController.delegate = self
        /// Assign page's controllers
        tabBarController.setViewControllers(tabControllers, animated: false)
        /// Let set index
        tabBarController.selectedIndex = TabBarPage.lastUploaded.pageOrderNumber()
        /// Styling
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .systemBackground
        tabBarController.tabBar.standardAppearance = appearance
        //tabBarController.tabBar.isTranslucent = false
        
        /// In this step, we attach tabBarController to navigation controller associated with this coordinator
        navigationController.viewControllers = [tabBarController]
    }
      
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(false, animated: false)

        navController.tabBarItem = UITabBarItem.init(title: page.pageTitleValue(),
                                                     image: page.pageTabIcon(),
                                                     tag: page.pageOrderNumber())

        switch page {
        case .profile:
            // If needed: Each tab bar flow can have it's own Coordinator.
            let profileVC = UserProfileViewController()
            navController.pushViewController(profileVC, animated: true)
        case .lastUploaded:
            let lastUploadedCoordinator = LastUploadedCoordinator(navController)
            lastUploadedCoordinator.start()
        case .allFiles:
            let allFilesVC = AllFilesViewController()
           
            navController.pushViewController(allFilesVC, animated: true)
        }
        
        return navController
    }
    
    func currentPage() -> TabBarPage? { TabBarPage.init(index: tabBarController.selectedIndex) }

    func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
    
    func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        
        tabBarController.selectedIndex = page.pageOrderNumber()
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        // Some implementation
        
    }
}
