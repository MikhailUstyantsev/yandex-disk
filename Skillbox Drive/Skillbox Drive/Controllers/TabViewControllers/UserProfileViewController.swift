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
    
    let showPublishedButton = UIButton.customButton(title: "Опубликованные файлы", backgroundColor: .systemBackground, titleColor: .label, fontSize: 18, radius: 5)
    
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

                guard let occupiedEntry = self?.viewModel?.occupiedData, let totalEntry = self?.viewModel?.totalData, let freeSpaceEntry = self?.viewModel?.freeSpace else { return }
                
                self?.pieChart.drawEntryLabelsEnabled = true
            
                self?.viewModel?.entries.append(
                        PieChartDataEntry(value: occupiedEntry/1000, label: "Занято"))
                self?.viewModel?.entries.append(
                        PieChartDataEntry(value: freeSpaceEntry/1000, label: "Доступно"))

                let set = PieChartDataSet(entries: self?.viewModel?.entries ?? [])
               
                set.colors = ChartColorTemplates.pastel()
                let myAttrString = NSAttributedString(string: "\(totalEntry/1000) ГБ", attributes: [
                    .font: UIFont.systemFont(ofSize: 24, weight: .regular),
                    .foregroundColor: UIColor.label
                ])
                self?.pieChart.centerAttributedText = myAttrString
                
                self?.pieChart.entryLabelColor = .label
                set.label = " Гигабайт"
                let data = PieChartData(dataSet: set)
                self?.pieChart.data = data
            }
        }
    }
    
    
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        title = "Профиль"
        pieChart.translatesAutoresizingMaskIntoConstraints = false
        let legend = pieChart.legend
        
        legend.horizontalAlignment = .left
        legend.verticalAlignment = .bottom
        legend.orientation = .vertical
        pieChart.holeColor = .systemBackground
        activityIndicator.center = view.center
        activityIndicator.style = .large
        pieChart.delegate = viewModel
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Выйти", style: .plain, target: self, action: #selector(logoutTapped))
        
        guard let arrow = UIImage(named: "rightArrow") else { return }
        
        showPublishedButton.contentHorizontalAlignment = .left
        showPublishedButton.addRightImage(image: arrow, offset: 5)
        showPublishedButton.addTarget(self, action: #selector(openPublishedTapped), for: .touchUpInside)
    }
    
    @objc private func logoutTapped() {
        self.presentLogoutAlert { [weak self] in
            self?.presentConfirmLogoutAlert { [weak self] in
                self?.viewModel?.logoutUserProfile()
            }
        }
    }
    
    @objc private func openPublishedTapped() {
        viewModel?.openPublishedFiles()
    }
    
    private func  setupHierarchy() {
        view.addSubviews(activityIndicator, pieChart, showPublishedButton)
    }
    
    
    
    private func setupLayout() {
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            pieChart.topAnchor.constraint(equalTo: margins.topAnchor),
            pieChart.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            pieChart.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 2),
            
            
            showPublishedButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            showPublishedButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            showPublishedButton.topAnchor.constraint(equalTo: pieChart.bottomAnchor, constant: 50)
        ])
    }

    
    
}
