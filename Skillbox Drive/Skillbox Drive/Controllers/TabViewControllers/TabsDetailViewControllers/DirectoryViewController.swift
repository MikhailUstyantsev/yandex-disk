//
//  DirectoryViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 26.03.2023.
//

import UIKit

final class DirectoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var dataViewModel: TableViewCellViewModel?
    var serviceViewModel: AllFilesViewModel?
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(YDTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
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
                    self?.showNoFilesLabel()
                }
                self?.tableView.reloadData()
            }
        }
        
        guard let path = dataViewModel?.filePath else { return }
        
        serviceViewModel?.fetchDirectoryFiles(path)
        
        serviceViewModel?.refreshTableView = { [weak self] in
            self?.serviceViewModel?.cellViewModels.removeAll()
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
        }
        
    }
    
    
    @objc func filesDidChanged(_ notification: Notification) {
        guard let path = dataViewModel?.filePath else { return }
        
        serviceViewModel?.cellViewModels.removeAll()
        serviceViewModel?.fetchDirectoryFiles(path)
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = dataViewModel?.name
        
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
        guard let viewModel = serviceViewModel?.cellViewModels[indexPath.row] else { return cell }
        cell.update(with: viewModel)
        cell.downloadButtonPressed = {
            print("download button tapped")
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let viewModelToPass = serviceViewModel?.cellViewModels[indexPath.row] else { return }
        guard let mediaType = serviceViewModel?.cellViewModels[indexPath.row].mediaType else { return }
        
        guard let dirType = serviceViewModel?.cellViewModels[indexPath.row].directoryType else { return }
        
        serviceViewModel?.didSelectRowAtDirectoryViewController(with: viewModelToPass, fileType: mediaType, directoryType: dirType)
        
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
            
            guard let path = self?.dataViewModel?.filePath else { return }
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight) {
                self?.serviceViewModel?.fetchAdditionalDirectoryFiles(path)
            }
            t.invalidate()
        }
    }
    
    @objc func didPullToRefresh() {
        guard let path = dataViewModel?.filePath else { return }
        serviceViewModel?.reFetchDirectoryData(path)
    }
    
    
}
