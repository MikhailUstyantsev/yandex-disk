//
//  AuthViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 23.09.2022.
//

import Foundation
import WebKit


final class AuthViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var viewModel: AuthViewModel?
   
    //call back URL указанный при регистрации приложения
    private let scheme = "myfiles"
    
    private let webView = WKWebView()
    
    //clientID мы копируем из браузера со страницы зарегистрированного приложения
    private let clientId: String = "d236e36b801346798d07d9a6e663fe8e"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
//        когда у нас есть правильный urlRequest, мы вызываем его в вебвью для авторизации пользователя
        guard let request = viewModel?.request else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
//        после успешного вызова в редиректе нам будет направлен токен, чтобы перехватить редирект нам нужно реализовать протокол делегата для вебвью
//        webView.navigationDelegate = self
                webView.navigationDelegate = viewModel


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.setHidesBackButton(true, animated: false)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(webView)
        
    }
    
    private func setupLayout() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        let margins = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            webView.topAnchor.constraint(equalTo: margins.topAnchor),
            webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
    
    deinit {
        print("AuthViewController deinit")
    }
    
}



