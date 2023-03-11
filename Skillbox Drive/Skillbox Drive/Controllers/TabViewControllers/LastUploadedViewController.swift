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
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Последние"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
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
        cell.selectionStyle = .default
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.didSelectRow(at: indexPath)
    }
    
    
    
    
}



