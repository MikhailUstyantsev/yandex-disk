//
//  ViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 27.07.2022.
//

import UIKit

class EnterViewController: UIViewController {

    var viewModel: LoginViewModel?
    
    
    private let enterView: LoginView = {
       let view = LoginView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }

    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(enterView)
        
        enterView.onButtonTap = { [weak self] in
            self?.viewModel?.enterButtonPressed()
        }
        
        NSLayoutConstraint.activate([
            enterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            enterView.topAnchor.constraint(equalTo: view.topAnchor),
            enterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            enterView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
    
    
    
    

}

