//
//  WKWebView + Extensions.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 14.03.2023.
//

import Foundation
import WebKit

extension WKWebView {
    func load(_ urlString: String, _ token: String) {
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("OAuth \(token)", forHTTPHeaderField: "Authorization")
            load(request)
        }
    }
}
