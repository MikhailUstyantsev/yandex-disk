//
//  AuthViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 23.09.2022.
//

import Foundation
import WebKit

//создаем протокол, который будет содержать метод передающий полученный токен
protocol AuthViewControllerDelegate: AnyObject {
    func handleTokenChanged(token: String)
}


final class AuthViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    
    var viewModel: AuthViewModel?
   
    weak var delegate: AuthViewControllerDelegate?
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
        guard let request = request else { return }
        
        DispatchQueue.main.async { [weak self] in
            self?.webView.load(request)
        }
//        после успешного вызова в редиректе нам будет направлен токен, чтобы перехватить редирект нам нужно реализовать протокол делегата для вебвью
        webView.navigationDelegate = self

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
    
//    напишем запрос для вебвью направляющий по адресу для получения токена
    private var request: URLRequest? {
//    нам потребуется указать параметры в адресе - response type и clientID - воспользуемся для создания url специальным классом: URLComponents
        guard var urlComponents = URLComponents(string: "https://oauth.yandex.ru/authorize") else { return nil }
//        далее мы указываем что в результирующем url должно быть два параметра - первый: response_type со значением token и второй, куда мы установили идентификатор зарегистрированного приложения
        urlComponents.queryItems = [
        URLQueryItem(name: "response_type", value: "token"),
        URLQueryItem(name: "client_id", value: "\(clientId)")
        ]
//        теперь мы можем сформировать url
        guard let url = urlComponents.url else { return nil}
//        далее создаем объект класса URLRequest с целью его дальнейшего использования в вебвью
        return URLRequest(url: url)
    }
    
    deinit {
        print("AuthViewController deinit")
    }
    
}

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == scheme {
//            если соответствует схеме "myfiles"
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            let token = components.queryItems?.first(where: { $0.name == "access_token"})?.value
            
            if let token = token {
                //попробую как альтернативу протокола делегата сохранить токен в user defaults
                defaults.set(token, forKey: "token")
//                delegate?.handleTokenChanged(token: token)
            }
            viewModel?.didSendEventClosure(.login)
        }
        decisionHandler(.allow)
    }
    
    
    
    
}


