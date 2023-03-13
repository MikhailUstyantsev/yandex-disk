//
//  LastUploadedDetailViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 13.03.2023.
//

import UIKit

class LastUploadedDetailViewController: UIViewController {
    
    var viewModel: LastUploadedDetailViewModel?
    
    let defaults = UserDefaults.standard
    
    var token: String = ""
    
    private let customImageView = ImageLoader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHierarchy()
        setupLayout()
        
        viewModel?.downloadFile(completion: { downloadResponse in
            self.token = self.defaults.object(forKey: "token") as? String ?? ""
            DispatchQueue.main.async {
                guard let url = URL(string: downloadResponse.href) else { return }
                self.customImageView.loadImageWithUrl(url, self.token)
            }
        })
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        customImageView.backgroundColor = .secondaryLabel
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true
    }
    
    private func setupHierarchy() {
        view.addSubviews(customImageView)
    }
    
    
    private func setupLayout() {
        customImageView.pinToSuperviewEdges()
        //NSLayoutConstraint.activate([ customImageView.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 3),
        //            customImageView.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
        //            customImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        //            customImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        //        ])
    }
    
    
    deinit {
        print("deinit from LastUploadedDetailViewController")
    }
    
}
