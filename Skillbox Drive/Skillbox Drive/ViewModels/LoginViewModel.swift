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
        //показываем онбординг если первый раз запущено приложение
        if !isAppAlreadyLaunchedOnce() {
            coordinator?.goToOnboarding()
        } else {
            //переходим сразу к авторизации если ранее приложение уже запускалось
            coordinator?.goToAuthPage()
        }
        
    }
    
}
