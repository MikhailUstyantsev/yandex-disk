//
//  LoginViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 06.03.2023.
//

import Foundation

final class LoginViewModel {
    
    let defaults = UserDefaults.standard
    
    
    var coordinator: LoginCoordinator?
    
    func isAppAlreadyLaunchedOnce() -> Bool {
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
            return true
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            return false
        }
    }
    
    func enterButtonPressed() {
        //показываем онбординг, если приложение запущено впервые
        if !isAppAlreadyLaunchedOnce() {
            coordinator?.goToOnboarding()
        } else if KeychainManager.shared.getTokenFromKeychain() == nil {
            /*
             переходим сразу к авторизации если ранее приложение уже запускалось, но токен
             например удален
             */
            coordinator?.goToAuthPage()
        } else {
            /*
             возможен третий сценарий - в случае если есть токен и приложение уже запускается не впервые, то можно сразу открывать main tab bar controller
             */
             coordinator?.finish()
        }
    }
    
    func enterButtonPressedWithNoNetwork() {
        
    }
    
}
