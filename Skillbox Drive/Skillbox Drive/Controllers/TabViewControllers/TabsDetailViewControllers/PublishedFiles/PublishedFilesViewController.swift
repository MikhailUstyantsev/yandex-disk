//
//  PublishedFilesViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 31.03.2023.
//

import UIKit

class PublishedFilesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataViewModel: TableViewCellViewModel?
    var serviceViewModel: PublishedFilesViewModel?
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(YDTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let noFilesImageView = UIImageView()
    private let noFilesLabel = UILabel()
    
    private let refreshButton = UIButton.customButton(title: Constants.Text.reload, backgroundColor: UIColor(red: 216/255, green: 233/255, blue: 234/255, alpha: 1.0), titleColor: .black, fontSize: 20, radius: 10)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.startAnimating()
        
        setupViews()
        setupHierarchy()
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(filesDidChanged(_:)), name: NSNotification.Name("filesDidChange"), object: nil)
        
        serviceViewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if self?.serviceViewModel?.cellViewModels.count == 0 {
                    //показать сообщение и картинку об отсутствии опубликованных файлов
                    self?.noFilesImageView.isHidden = false
                    self?.noFilesLabel.isHidden = false
                    self?.refreshButton.isHidden = false
                }
                self?.tableView.reloadData()
            }
        }
        
        serviceViewModel?.fetchPublishedFiles()
        
        serviceViewModel?.refreshTableView = { [weak self] in
            self?.serviceViewModel?.cellViewModels.removeAll()
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                if self?.serviceViewModel?.cellViewModels.count == 0 {
                    //показать сообщение и картинку об отсутствии опубликованных файлов
                    self?.noFilesImageView.isHidden = true
                    self?.noFilesLabel.isHidden = true
                    self?.refreshButton.isHidden = true
                }
                self?.tableView.reloadData()
            }
        }
        
        
    }
    

    @objc func filesDidChanged(_ notification: Notification) {
        serviceViewModel?.cellViewModels.removeAll()
        serviceViewModel?.fetchPublishedFiles()
    }
    
    private func setupViews() {
        title = Constants.Text.publishedFiles
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        activityIndicator.color = .darkGray
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        noFilesImageView.translatesAutoresizingMaskIntoConstraints = false
        noFilesImageView.isHidden = true
        noFilesImageView.image = UIImage(named: "folderEmpty")
        noFilesImageView.contentMode = .scaleAspectFit
        
        noFilesLabel.translatesAutoresizingMaskIntoConstraints = false
        noFilesLabel.isHidden = true
        noFilesLabel.text = Constants.Text.haveNopublishedFiles
        noFilesLabel.numberOfLines = 2
        noFilesLabel.textAlignment = .center
        noFilesLabel.textColor = .label
        noFilesLabel.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        
        refreshButton.isHidden = true
        refreshButton.addTarget(self, action: #selector(didPullToRefresh), for: .touchUpInside)
    }

    
    private func setupHierarchy() {
        view.addSubviews(tableView, activityIndicator, noFilesImageView, noFilesLabel, refreshButton)
    }
    
    
    private func  setupLayout() {
        tableView.pinToSuperviewEdges()
        
        let margins = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noFilesImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            noFilesImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            noFilesImageView.centerYAnchor.constraint(equalTo: margins.centerYAnchor, constant: -50),
            noFilesImageView.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 3),
            
            noFilesLabel.topAnchor.constraint(equalTo: noFilesImageView.bottomAnchor, constant: 20),
            noFilesLabel.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 30),
            noFilesLabel.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -30),
            
            margins.bottomAnchor.constraint(equalTo: refreshButton.bottomAnchor, constant: 92),
            refreshButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 27),
            margins.trailingAnchor.constraint(equalTo: refreshButton.trailingAnchor, constant: 27),
            refreshButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YDTableViewCell
        guard let viewModel = serviceViewModel?.cellViewModels[indexPath.row] else { return cell }
        cell.update(with: viewModel)
        cell.downloadButtonPressed = { [weak self] in
            self?.presentPublishedFileActionsAlert(title: viewModel.name, action1: {
                print("download file tapped")
            }, action2: {
                self?.activityIndicator.startAnimating()
                self?.serviceViewModel?.unpublishFile(viewModel.filePath)
            })
            // 1. Сохранить вьюмодель данной ячейки в CoreData
            // 2. Добавить эту модель в отдельный массив во вью модели контроллера - что-то вроде downloadedCellViewModels? - с ним вероятно работать при отсутствии интернета?
            // 3. Обновить картинку кнопки загрузки на "download.finish"
        }
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceViewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        guard let isShowLoader = serviceViewModel?.isShowLoader else { return }
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && isShowLoader && serviceViewModel?.cellViewModels.count ?? 0 >= 20 {
            tableView.showLoadingFooter()
        } else {
            tableView.hideLoadingFooter()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModelToPass = serviceViewModel?.cellViewModels[indexPath.row] else { return }
        guard let mediaType = serviceViewModel?.cellViewModels[indexPath.row].mediaType else { return }
        
        guard let dirType = serviceViewModel?.cellViewModels[indexPath.row].directoryType else { return }
        
        serviceViewModel?.didSelectRow(with: viewModelToPass, fileType: mediaType, directoryType: dirType)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !serviceViewModel!.isLoadingMoreData,
              !serviceViewModel!.cellViewModels.isEmpty
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight) {
                self?.serviceViewModel?.fetchAdditionalPublishedFiles()
            }
            t.invalidate()
        }
    }
    
    @objc func didPullToRefresh() {
        serviceViewModel?.reFetchData()
    }
    
    
    deinit {
        print("deinit from PublishedFilesViewController")
    }
}

