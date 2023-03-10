//
//  AuthViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 06.03.2023.
//

import Foundation

final class AuthViewModel {
    
    var coordinator: LoginCoordinator?
    
    var didSendEventClosure: ((AuthViewModel.Event) -> Void) = {_ in }
     
    enum Event {
        case login
    }
    
}
