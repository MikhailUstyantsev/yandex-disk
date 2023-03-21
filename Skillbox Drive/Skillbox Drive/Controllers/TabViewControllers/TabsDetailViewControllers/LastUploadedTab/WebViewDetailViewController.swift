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
    
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    
    var items = [UIBarButtonItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(renameTapped))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrowshape.turn.up.backward"), style: .plain, target: self, action: #selector(backTapped))
        
        let shareToolBarButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareTapped))
        items.append(shareToolBarButton)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        items.append(spacer)
        
        let deleteToolBarButton = UIBarButtonItem(image: UIImage(systemName: "trash"), style: .plain, target: self, action: #selector(deleteTapped))
        items.append(deleteToolBarButton)
    
        toolbarItems = items
        
        navigationController?.setToolbarHidden(false, animated: false)
        
        setupViews()
        setupHierarchy()
        setupLayout()
        
        activityIndicator.startAnimating()
        
        viewModel?.downloadFile(completion: { downloadResponse in
            DispatchQueue.main.async {
                self.webView.load(downloadResponse.href)
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
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: margins.topAnchor),
            webView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
        ])
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    @objc private func renameTapped() {
//        viewModel?.renameFile()
    }
    
    @objc private func shareTapped() {
        viewModel?.shareFile()
    }
    
    @objc private func deleteTapped() {
        viewModel?.deleteFile()
    }
    
    deinit {
        print("deinit from WebViewDetailViewController")
    }
    
    
}
