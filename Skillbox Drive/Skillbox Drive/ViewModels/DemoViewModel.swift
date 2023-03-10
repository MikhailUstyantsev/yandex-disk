//
//  DemoViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 06.03.2023.
//

import Foundation


final class DemoViewModel {
    
    var coordinator: LoginCoordinator?
    
    func showAuthPage() {
        coordinator?.goToAuthPage()
    }
}
