//
//  WebViewDetailViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 15.03.2023.
//

import Foundation
import WebKit

class WebViewDetailViewController: UIViewController,  WKNavigationDelegate, WKUIDelegate {
    
    var viewModel: DetailViewControllerViewModel?
    
    private let webView = WKWebView()
    private let activityIndicator = UIActivityIndicatorView()
    private let `label` = UILabel()
    var items = [UIBarButtonItem]()
    
    var downloadFileURLString: String = ""
    
    var dataToShare: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.onDeleteUpdate = { [weak self] deleteResponse in
            NotificationCenter.default.post(name: NSNotification.Name("filesDidChange"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dismiss(animated: true)
                guard let label = self?.label else { return }
                self?.removeDeleteLabel(label)
            }
        }
        
        viewModel?.onRenameUpdate = { [weak self] renameResponse in
            NotificationCenter.default.post(name: NSNotification.Name("filesDidChange"), object: nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dismiss(animated: true)
                guard let label = self?.label else { return }
                self?.removeRenamingLabel(label)
            }
        }
        
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
            self.downloadFileURLString = downloadResponse.href
            // setting up the local URL
            let localURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            // setting up the local URL to the file itself
            let fileName = self.viewModel?.cellViewModel?.name
            let fileURL = URL(fileURLWithPath: "\(fileName ?? "unknown")", relativeTo: localURL).appendingPathExtension("\(self.viewModel?.cellViewModel?.mediaType ?? "unknown")")
            // download the file and save to local storage
            if let downloadFileURL = URL(string: self.downloadFileURLString) {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: downloadFileURL)
                    DispatchQueue.main.async {
                        do {
                            try? data?.write(to: fileURL)
                        }
                        //present file into webView using link to local storage
                        self.webView.load(fileURL.absoluteString)
                    }
                }
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
        guard let name = viewModel?.cellViewModel?.name else { return }
        self.presentRenameAlert(name: name) { [weak self] newName in
            guard let label = self?.label else { return }
            self?.viewModel?.renameFile(newName)
            self?.showRenamingLabel(label)
        }
    }
    
    
    @objc private func shareTapped() {
        //viewModel?.shareFile()
        self.presentShareAlert { [weak self] in
            let fileName = self?.viewModel?.cellViewModel?.name as Any
            /*
             Cкачивание файла по ссылке и сохранение в локальном хранилище реализовано во ViewDidLoad, в момент передачи файла я делюсь ссылкой на локальное хранилище - и файл просто скачивается оттуда, например в мессенджер какому-то адресату или системное приложение Files
             */
            if let webViewData = self?.webView.url {
                    let vc = UIActivityViewController(activityItems: [webViewData, fileName], applicationActivities: [])
                    DispatchQueue.main.async {
                        vc.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                        self?.present(vc, animated: true)
                    }
                }
        } action2: { [weak self] in
            self?.viewModel?.shareReferenceToFile()
            self?.viewModel?.shareFileURL = { [weak self] publicURLstring in
                let url = URL(string: publicURLstring) as Any
                let vc = UIActivityViewController(activityItems: [url], applicationActivities: [])
                DispatchQueue.main.async {
                    vc.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                    self?.present(vc, animated: true)
                }
            }
        }
        
    }
    
    @objc private func deleteTapped() {
        self.presentDeleteAlert { [weak self] in
            self?.viewModel?.deleteFile()
            guard let label = self?.label else { return }
            self?.showDeleteLabel(label)
        }
    }
    
    deinit {
        print("deinit from WebViewDetailViewController")
    }
    
    
}
