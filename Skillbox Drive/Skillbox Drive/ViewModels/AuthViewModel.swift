//
//  AuthViewModel.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 06.03.2023.
//

import Foundation
import WebKit

final class AuthViewModel: NSObject {
    
    var coordinator: LoginCoordinator?
    
    var didSendEventClosure: ((AuthViewModel.Event) -> Void) = {_ in }
    
    enum Event {
        case login
    }
    
    //call back URL указанный при регистрации приложения
    private let scheme = "myfiles"
    
    //clientID мы копируем из браузера со страницы зарегистрированного приложения
    private let clientId: String = "d236e36b801346798d07d9a6e663fe8e"
    
    //напишем запрос для вебвью направляющий по адресу для получения токена
    var request: URLRequest? {
        //нам потребуется указать параметры в адресе - response type и clientID - воспользуемся для создания url специальным классом: URLComponents
        guard var urlComponents = URLComponents(string: "https://oauth.yandex.ru/authorize") else { return nil }
        //далее мы указываем что в результирующем url должно быть два параметра - первый: response_type со значением token и второй, куда мы установили идентификатор зарегистрированного приложения
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "client_id", value: "\(clientId)")
        ]
        //теперь мы можем сформировать url
        guard let url = urlComponents.url else { return nil}
        //далее создаем объект класса URLRequest с целью его дальнейшего использования в вебвью
        return URLRequest(url: url)
    }
    
}


extension AuthViewModel: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url, url.scheme == scheme {
            //если соответствует схеме "myfiles"
            let targetString = url.absoluteString.replacingOccurrences(of: "#", with: "?")
            guard let components = URLComponents(string: targetString) else { return }
            
            let token = components.queryItems?.first(where: { $0.name == "access_token"})?.value
            
            if let token = token {
                //MARK: сохранение ключа в Keychain
                KeychainManager.shared.saveTokenInKeychain(token)
            }
            didSendEventClosure(.login)
        }
        decisionHandler(.allow)
    }
  
    
    
}
