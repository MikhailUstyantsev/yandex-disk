//
//  WKWebView + Extensions.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 14.03.2023.
//

import Foundation
import WebKit

extension WKWebView {
    func load(_ urlString: String) {
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            load(request)
        }
    }
}
