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
    
    let defaults = UserDefaults.standard
    private let activityIndicator = UIActivityIndicatorView()
    var token: String = ""
    let pdfView = PDFView()
    var resourceUrl: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        setupViews()
        setupHierarchy()
        setupLayout()
        
        viewModel?.downloadFile(completion: { downloadResponse in
            self.token = self.defaults.object(forKey: "token") as? String ?? ""
            self.resourceUrl = URL(string: downloadResponse.href)
            self.displayPdf()
        })
    }
    
    private func displayPdf() {
        DispatchQueue.main.async {
            if let pdfDocument = self.createPdfDocument() {
                self.pdfView.document = pdfDocument
                self.activityIndicator.stopAnimating()
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
        let margins = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            pdfView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: margins.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: margins.centerYAnchor)
        ])
    }
    
    
    
    
    
    
    deinit {
        print("deinit from PDFViewDetailViewController")
    }
}
