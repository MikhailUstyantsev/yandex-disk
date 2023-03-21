//
//  PDFViewDetailViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 15.03.2023.
//

import UIKit
import PDFKit

class PDFViewDetailViewController: UIViewController {
    
    var viewModel: LastUploadedDetailViewModel?
    
    private let activityIndicator = UIActivityIndicatorView()
    let pdfView = PDFView()
    var resourceUrl: URL?
    
    var items = [UIBarButtonItem]()
    
    override func viewDidLoad() {
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
        
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems = [ UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(renameTapped)),
                                                    ]
        
        activityIndicator.startAnimating()
        setupViews()
        setupHierarchy()
        setupLayout()
        
        viewModel?.downloadFile(completion: { downloadResponse in
            self.resourceUrl = URL(string: downloadResponse.href)
            self.displayPdf()
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
        })
        
    }
    
    private func displayPdf() {
        DispatchQueue.main.async {
            if let pdfDocument = self.createPdfDocument() {
                self.pdfView.document = pdfDocument
            }
        }
    }
    
    private func createPdfDocument() -> PDFDocument? {
        if let url = resourceUrl  {
            return PDFDocument(url: url)
        }
        return nil
    }
    
    
    private func setupViews() {
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.autoScales = true
        if let titleString = viewModel?.cellViewModel?.name, let subtitleString = viewModel?.cellViewModel?.date
        {
            let resultSubtitle = viewModel?.prepareSubtitle(subtitle: subtitleString) ?? "unknown date and time"
            navigationItem.setTitle(title: titleString, subtitle: resultSubtitle)
        }
        view.backgroundColor = .systemBackground
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setupHierarchy() {
        view.addSubviews(pdfView, activityIndicator)
    }
    
    private func setupLayout() {
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: margins.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
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
        print("deinit from PDFViewDetailViewController")
    }
}
