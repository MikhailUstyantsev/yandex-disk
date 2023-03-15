//
//  WebViewDetailViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 15.03.2023.
//

import Foundation
import WebKit

class WebViewDetailViewController: UIViewController,  WKNavigationDelegate, WKUIDelegate {
    
    var viewModel: LastUploadedDetailViewModel?
    
    let defaults = UserDefaults.standard
    
    var token: String = ""
    
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHierarchy()
        setupLayout()
        
        activityIndicator.startAnimating()
        
        viewModel?.downloadFile(completion: { downloadResponse in
            self.token = self.defaults.object(forKey: "token") as? String ?? ""
            DispatchQueue.main.async {
                self.webView.load(downloadResponse.href, self.token)
            }
        })
    }
    
    private func setupViews() {
        webView.navigationDelegate = self
        webView.uiDelegate = self
        
        if let titleString = viewModel?.cellViewModel?.name, let subtitleString = viewModel?.cellViewModel?.date
        {
            let resultSubtitle = viewModel?.prepareSubtitle(subtitle: subtitleString) ?? "unknown date and time"
            navigationItem.setTitle(title: titleString, subtitle: resultSubtitle)
        }
        view.backgroundColor = .systemBackground
        webView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    private func setupHierarchy() {
        view.addSubviews(webView, activityIndicator)
    }
    
    private func setupLayout() {
        let margins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            webView.topAnchor.constraint(equalTo: margins.topAnchor),
            webView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        ])
    }
    
    
    
    
    deinit {
        print("deinit from WebViewDetailViewController")
    }
    
    
}
