//
//  LastUploadedDetailViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 13.03.2023.
//

import UIKit

class ImageViewDetailViewController: UIViewController {
    
    var viewModel: LastUploadedDetailViewModel?
    
    let defaults = UserDefaults.standard
    
    var token: String = ""
    
    private let imageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupHierarchy()
        setupLayout()
        
        viewModel?.downloadFile(completion: { downloadResponse in
            self.token = self.defaults.object(forKey: "token") as? String ?? ""
            DispatchQueue.main.async {
                guard let url = URL(string: downloadResponse.href) else { return }
                self.imageView.sd_setImage(with: url)
            }
        })
    }
    
    private func setupViews() {
        if let titleString = viewModel?.cellViewModel?.name, let subtitleString = viewModel?.cellViewModel?.date
        {
            let resultSubtitle = viewModel?.prepareSubtitle(subtitle: subtitleString) ?? "unknown date and time"
            navigationItem.setTitle(title: titleString, subtitle: resultSubtitle)
        }
        view.backgroundColor = .systemBackground
        imageView.backgroundColor = .systemBackground
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
    }
    
    private func setupHierarchy() {
        view.addSubviews(imageView)
    }
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([ imageView.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 1.35),
          imageView.widthAnchor.constraint(equalToConstant: view.bounds.size.width),
          imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                    ])
    }
    
    
    deinit {
        print("deinit from ImageViewDetailViewController")
    }
    
}
