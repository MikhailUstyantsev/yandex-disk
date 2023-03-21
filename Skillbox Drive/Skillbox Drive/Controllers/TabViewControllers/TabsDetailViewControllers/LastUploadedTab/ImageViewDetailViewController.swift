//
//  LastUploadedDetailViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 13.03.2023.
//

import UIKit



class ImageViewDetailViewController: UIViewController {
    
    var viewModel: LastUploadedDetailViewModel?
    
    private let resizableImageView = PanZoomImageView()
    private let activityIndicator = UIActivityIndicatorView()
    
    var items = [UIBarButtonItem]()
    
    let renamingLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.onUpdate = { [weak self] renameResponse in
            NotificationCenter.default.post(name: NSNotification.Name("fileNameDidChange"), object: nil)
            //при необходимости можно притащить с сервера новое имя и засетить в тайтл
            //сделал небольшую задержку, чтобы дать время обновить данные в LastUploadedViewController после выпуска нотификации
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dismiss(animated: true)
                guard let label = self?.renamingLabel else { return }
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
        
        activityIndicator.startAnimating()
        setupViews()
        setupHierarchy()
        setupLayout()
        
        viewModel?.downloadFile(completion: { downloadResponse in
            DispatchQueue.main.async {
                guard let url = URL(string: downloadResponse.href) else { return }
                self.resizableImageView.imageView.sd_setImage(with: url) {_,_,_,_ in
                    self.activityIndicator.stopAnimating()
                }
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
        resizableImageView.backgroundColor = .systemBackground
        resizableImageView.translatesAutoresizingMaskIntoConstraints = false
        resizableImageView.contentMode = .scaleAspectFit
        resizableImageView.clipsToBounds = true
        
        activityIndicator.color = .darkGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHierarchy() {
        view.addSubviews(resizableImageView, activityIndicator)
    }
    
    private func setupLayout() {
        
        let margins = view.layoutMarginsGuide
        
        NSLayoutConstraint.activate([ resizableImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          resizableImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          resizableImageView.topAnchor.constraint(equalTo: margins.topAnchor),
          resizableImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
      
      activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func backTapped() {
        dismiss(animated: true)
    }
    
    
    @objc private func renameTapped() {
        guard let name = viewModel?.cellViewModel?.name else { return }
        self.showRenameAlert(name: name) { [weak self] newName in
            guard let label = self?.renamingLabel else { return }
            self?.viewModel?.renameFile(newName)
            self?.showRenamingLabel(label)
        }
    }
    
    @objc private func shareTapped() {
        viewModel?.shareFile()
    }
    
    @objc private func deleteTapped() {
        viewModel?.deleteFile()
    }
    
    deinit {
        print("deinit from ImageViewDetailViewController")
    }
    
}


