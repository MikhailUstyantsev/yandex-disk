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
    
    let `label` = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.onDeleteUpdate = { [weak self] deleteResponse in
            NotificationCenter.default.post(name: NSNotification.Name("filesDidChange"), object: nil)
//            отправляя GET запрос по ссылке, полученной в блоке success удаления файла (тело ответа мы получаем только для непустой папки), мы можем узнать текущий статус операции удаления
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.dismiss(animated: true)
                guard let label = self?.label else { return }
                self?.removeDeleteLabel(label)
            }
        }
        
        viewModel?.onRenameUpdate = { [weak self] renameResponse in
            NotificationCenter.default.post(name: NSNotification.Name("filesDidChange"), object: nil)
            //при необходимости можно притащить с сервера новое имя и засетить в тайтл
//            self?.viewModel?.getFileProperty(renameResponse.href, completion: { fileMetaDataResponse in
            //сделал небольшую задержку, чтобы дать время обновить данные в LastUploadedViewController после выпуска нотификации
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.dismiss(animated: true)
                    guard let label = self?.label else { return }
                    self?.removeRenamingLabel(label)
                }
//          })
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
        self.presentRenameAlert(name: name) { [weak self] newName in
            guard let label = self?.label else { return }
            self?.viewModel?.renameFile(newName)
            self?.showRenamingLabel(label)
        }
    }
    
    @objc private func deleteTapped() {
        self.presentDeleteAlert { [weak self] in
            self?.viewModel?.deleteFile()
            guard let label = self?.label else { return }
            self?.showDeleteLabel(label)
        }
    }
    
    @objc private func shareTapped() {
        self.presentShareAlert { [weak self] in
            guard let imageData = self?.resizableImageView.imageView.image?.jpegData(compressionQuality: 0.8) else {
                print("No image found")
                return
            }
            let image = UIImage(data: imageData) as Any
            let imageName = self?.viewModel?.cellViewModel?.name as Any
            let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
            DispatchQueue.main.async {
                vc.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                self?.present(vc, animated: true)
            }
//            self?.viewModel?.shareFile()
            
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
    
    
    deinit {
        print("deinit from ImageViewDetailViewController")
    }
    
}


