//
//  RecentlyLoadItemsViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 23.09.2022.
//

import UIKit
import Network

class LastUploadedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, NetworkCheckObserver {
   
    
    var networkCheck = NetworkCheck.sharedInstance()
    
    var viewModel: LastUploadedViewModel?
    
    let `label` = UILabel()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(YDTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if networkCheck.currentStatus == .satisfied {
            //Do something
            viewModel?.fetchFiles()
        } else {
            //Show no network alert
            self.showNoConnectionLabel(label)
            print("No network connection")
        }
        networkCheck.addObserver(observer: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(filesDidChanged(_:)), name: NSNotification.Name("filesDidChange"), object: nil)
        
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
        setupViews()
        setupHierarchy()
        setupLayout()
        
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
                viewModel?.cellViewModels.removeAll()
                viewModel?.fetchFiles()
                print("We're online!")
            } else if status == .unsatisfied {
                //Show no network alert
                viewModel?.cellViewModels.removeAll()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                self.showNoConnectionLabel(label)
                print("No network connection")
            }
        }
        
    //        As you turn on wifi, It notify for NWPath update but until then connection has not been established, it takes some moment to connect
    //        The pathUpdateHandler does not work properly in an iOS simulator but works as expected on a real device.
    
    @objc func filesDidChanged(_ notification: Notification) {
        viewModel?.cellViewModels.removeAll()
        viewModel?.fetchFiles()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Последние"
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
        cell.savedFileImageView.isHidden = true
        cell.downloadButtonPressed = { [weak self] in
            self?.presentLastUploadedFileActionsAlert(title: "\(viewModel.name)", action: {
                self?.viewModel?.downloadFileToCoreData(viewModel)
            })
            // 1. Сохранить вьюмодель данной ячейки в CoreData
            // 2. Добавить эту модель в отдельный массив во вью модели контроллера - что-то вроде downloadedCellViewModels? - с ним вероятно работать при отсутствии интернета?
            // 3. Показать картинку сохранения файла на - cell.savedFileImageView.isHidden = false
        }
        cell.selectionStyle = .default
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModelToPass = viewModel?.cellViewModels[indexPath.row] else { return }
        guard let mediaType = viewModel?.cellViewModels[indexPath.row].mediaType else { return }
        viewModel?.didSelectRow(with: viewModelToPass, fileType: mediaType)
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



