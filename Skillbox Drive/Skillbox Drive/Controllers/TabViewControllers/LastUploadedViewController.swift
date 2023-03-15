//
//  RecentlyLoadItemsViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 23.09.2022.
//

import UIKit

class LastUploadedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: LastUploadedViewModel?
    
    let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: .plain)
        table.register(LastUploadedTableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
        setupHierarchy()
        setupLayout()
        
        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
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
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Последние"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 70
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        tableView.pinToSuperviewEdges()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LastUploadedTableViewCell
        guard let viewModel = viewModel?.cellViewModels[indexPath.row] else { return cell }
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
        return viewModel?.cellViewModels.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModelToPass = viewModel?.cellViewModels[indexPath.row] else { return }
        guard let mediaType = viewModel?.cellViewModels[indexPath.row].mediaType else { return }
        viewModel?.didSelectRow(with: viewModelToPass, fileType: mediaType)
    }
    
    
    @objc func didPullToRefresh() {
        viewModel?.reFetchData()
    }
    
}



