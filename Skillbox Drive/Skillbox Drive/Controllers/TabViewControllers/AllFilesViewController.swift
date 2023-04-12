//
//  AllFilesViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import UIKit
import Network

class AllFilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NetworkCheckObserver {
    
    var viewModel: AllFilesViewModel?
    
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
        
        
        if networkCheck.currentStatus == .satisfied {
            //Do something
            activityIndicator.startAnimating()
            viewModel?.fetchFiles()
            viewModel?.fetchFilesFromCoreData()
        } else {
            //Show no network alert
            self.showNoConnectionLabel(label)
            viewModel?.fetchFilesFromCoreData()
        }
        
        networkCheck.addObserver(observer: self)
        
       
        
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
        
        viewModel?.refreshTableView = { [weak self] in
            self?.viewModel?.cellViewModels.removeAll()
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        
    }
    
    //        MARK: - Change of Network Status

        func statusDidChange(status: NWPath.Status) {
                if status == .satisfied {
                           //Do something
                    self.removeNoConnectionLabel(label)
                    
                    NSLayoutConstraint.deactivate(offlineConstraints)
                    NSLayoutConstraint.activate(onlineConstraints)
                    
                    viewModel?.cellViewModels.removeAll()
                    viewModel?.fetchFiles()
                } else if status == .unsatisfied {
                    //Show no network alert
                    
                    NSLayoutConstraint.deactivate(onlineConstraints)
                    NSLayoutConstraint.activate(offlineConstraints)
                    
                    self.showNoConnectionLabel(label)
                    viewModel?.cellViewModels.removeAll()
                    viewModel?.fetchFilesFromCoreData()
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
    
    
    //   MARK: - Constraints
        
        private lazy var commonConstraints: [NSLayoutConstraint] = {
            return [
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ]
        }()
    
    private lazy var onlineConstraints: [NSLayoutConstraint] = {
       return [
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
       ]
    }()
    
    private lazy var offlineConstraints: [NSLayoutConstraint] = {
       return [
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
       ]
    }()
    
    
    private func setupLayout() {
        
            NSLayoutConstraint.activate(commonConstraints)
            if networkCheck.currentStatus == .satisfied {
                NSLayoutConstraint.activate(onlineConstraints)
            } else {
                NSLayoutConstraint.activate(offlineConstraints)
            }
        
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? YDTableViewCell else {
            return UITableViewCell()
        }
        
        if networkCheck.currentStatus == .satisfied {
            
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
                // сохранить из CoreData
                print("cell button tapped")
                // 1. Сохранить вьюмодель данной ячейки в CoreData
                // 2. Добавить эту модель в отдельный массив во вью модели контроллера - что-то вроде downloadedCellViewModels? - с ним вероятно работать при отсутствии интернета?
                // 3. Обновить картинку кнопки загрузки на "download.finish"
            }
        } else {
            if let viewModel = viewModel?.savedInCoreDataFiles[indexPath.row] {
                cell.nameLabel.text = viewModel.name
                cell.sizeLabel.text = viewModel.size
                cell.dateLabel.text = viewModel.created
                if let data = viewModel.image {
                    cell.cellImageView.image = UIImage(data: data)
                }
                cell.savedFileImageView.image = UIImage(named: "mark.saved")
                cell.downloadButtonPressed = {
                    // удалить из CoreData
                }
            }
        }
            
        cell.selectionStyle = .default
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if networkCheck.currentStatus == .satisfied {
            return viewModel?.cellViewModels.count ?? 0
        } else {
            if viewModel?.savedInCoreDataFiles.count ?? 0 < 20 {
                viewModel?.isShowLoader = false
            }
            return viewModel?.savedInCoreDataFiles.count ?? 0
        }
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
        
        if networkCheck.currentStatus == .satisfied {
            guard let viewModelToPass = viewModel?.cellViewModels[indexPath.row] else { return }
            guard let mediaType = viewModel?.cellViewModels[indexPath.row].mediaType else { return }
            
            guard let dirType = viewModel?.cellViewModels[indexPath.row].directoryType else { return }
            
            viewModel?.didSelectRow(with: viewModelToPass, fileType: mediaType, directoryType: dirType)
        } else {
            
        }
 
        
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
