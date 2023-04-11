//
//  AllFilesViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import UIKit
import Network

class AllFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var viewModel: AllFilesViewModel?
    
    var count: Int = 0
    
    var networkCheck = NetworkCheck.sharedInstance()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(YDTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let `label` = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        setupViews()
        setupHierarchy()
        setupLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(filesDidChanged(_:)), name: NSNotification.Name("filesDidChange"), object: nil)
        
        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
        }
        
        viewModel?.fetchFiles()
        
        viewModel?.refreshTableView = { [weak self] in
            self?.viewModel?.cellViewModels.removeAll()
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        
    }
    
    @objc func filesDidChanged(_ notification: Notification) {
        viewModel?.cellViewModels.removeAll()
        viewModel?.fetchFiles()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = Constants.Text.allFilesScreenTitle
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        activityIndicator.color = .darkGray
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupHierarchy() {
        view.addSubviews(tableView, activityIndicator)
    }
    
    private func setupLayout() {
        tableView.pinToSuperviewEdges()
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! YDTableViewCell
        guard let viewModel = viewModel?.cellViewModels[indexPath.row] else { return cell }
        cell.update(with: viewModel)
      
        if CoreDataManager.shared.checkIfItemExist(md5: viewModel.md5) {
                cell.savedFileImageView.image = UIImage(named: "mark.saved")
        } else {
            cell.savedFileImageView.image = UIImage(named: "mark.unsaved")
        }
       
        
        YDService.shared.downloadFile(path: viewModel.filePath) { downloadResponse in
                // setting up the local cache URL
                let localCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
                // setting up the local cache file URL to the file itself using unique ID - md5
            let localFileURL = localCacheURL.appendingPathComponent(viewModel.md5)
                DispatchQueue.global().async {
                    if let downloadFileURL = URL(string: downloadResponse.href) {
                        let data = try? Data(contentsOf: downloadFileURL)
                        DispatchQueue.main.async {
                            do {
                                try? data?.write(to: localFileURL)
                            }
                        }
                        let filePath = localFileURL.path
                        if let dataToSave = data {
                            //таким образом по адресу localFileURL.path будет лежать файл с уникальным идентификатором md5 и данными dataToSave
                            YDService.shared.moveItemToLocalStorage(filePath: filePath, data: dataToSave)
                    }
                }
            }
        }
        
        
        cell.downloadButtonPressed = {
            print("cell button tapped")
            // 1. Сохранить вьюмодель данной ячейки в CoreData
            // 2. Добавить эту модель в отдельный массив во вью модели контроллера - что-то вроде downloadedCellViewModels? - с ним вероятно работать при отсутствии интернета?
            // 3. Обновить картинку кнопки загрузки на "download.finish"
        }
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        guard let isShowLoader = viewModel?.isShowLoader else { return }
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex && isShowLoader {
            tableView.showLoadingFooter()
        } else {
            tableView.hideLoadingFooter()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewModelToPass = viewModel?.cellViewModels[indexPath.row] else { return }
        guard let mediaType = viewModel?.cellViewModels[indexPath.row].mediaType else { return }
        
        guard let dirType = viewModel?.cellViewModels[indexPath.row].directoryType else { return }
        
        viewModel?.didSelectRow(with: viewModelToPass, fileType: mediaType, directoryType: dirType)
        
 
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard !viewModel!.isLoadingMoreData,
              !viewModel!.cellViewModels.isEmpty
        else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight) {
                self?.viewModel?.fetchAdditionalFiles()
            }
            t.invalidate()
        }
    }
    
    @objc func didPullToRefresh() {
        viewModel?.reFetchData()
    }
}
