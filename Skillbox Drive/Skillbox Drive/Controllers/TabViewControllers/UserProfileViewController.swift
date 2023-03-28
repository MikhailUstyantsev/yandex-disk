//
//  UserProfileViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 07.03.2023.
//

import UIKit
import Charts

class UserProfileViewController: UIViewController, ChartViewDelegate {

    var viewModel: UserProfileViewModel?
    
    private let activityIndicator = UIActivityIndicatorView()
    
    let pieChart = PieChartView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupHierarchy()
        
        activityIndicator.startAnimating()
        
        viewModel?.fetchDiskData()
        
        setupLayout()
        
        viewModel?.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()

                guard let occupiedEntry = self?.viewModel?.occupiedData, let totalEntry = self?.viewModel?.totalData else { return }
                
                self?.pieChart.drawEntryLabelsEnabled = true
            
                self?.viewModel?.entries.append(
                        PieChartDataEntry(value: occupiedEntry, label: "Занято"))
                self?.viewModel?.entries.append(
                        PieChartDataEntry(value: totalEntry, label: "Всего"))

                let set = PieChartDataSet(entries: self?.viewModel?.entries ?? [])
                set.colors = ChartColorTemplates.material()
                set.label = "Мегабайт"
                let data = PieChartData(dataSet: set)
                self?.pieChart.data = data
            }
        }
    }
    
    
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Профиль"
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.center = view.center
        activityIndicator.style = .large
        pieChart.delegate = viewModel
    }
    
    
    
    
    private func  setupHierarchy() {
        view.addSubviews(activityIndicator, pieChart)
    }
    
    
    
    private func setupLayout() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: margins.topAnchor),
            pieChart.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 2)
        ])
    }

    
    
}
