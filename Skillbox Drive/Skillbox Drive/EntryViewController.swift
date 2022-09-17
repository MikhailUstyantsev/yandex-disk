//
//  ViewController.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 27.07.2022.
//

import UIKit

class EntryViewController: UIViewController {

    var firstTime = true
    lazy var margins = view.safeAreaLayoutGuide
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Vector")
        return imageView
    }()
    
    private let skillboxImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "Skillbox Drive")
       return imageView
    }()
    
    private lazy var stackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [logoImageView, skillboxImageView])
        stackView.spacing = 29
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let enterButton = UIButton.customButton(title: "Войти", backgroundColor: UIColor(named: "EnterButton") ?? .systemBlue, titleColor: .white, fontSize: 16, radius: 10)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if firstTime {
            configureView(for: traitCollection)
            firstTime = false
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        view.addSubview(enterButton)

        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        enterButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 27).isActive = true
        margins.trailingAnchor.constraint(equalTo: enterButton.trailingAnchor, constant: 27).isActive = true
       
        enterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }

    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
            configureView(for: traitCollection)
        }
    }
    
    
    private func configureView(for traitCollection: UITraitCollection) {
        if traitCollection.verticalSizeClass == .compact {
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 271).isActive = false
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
            
            margins.bottomAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 40).isActive = true
            margins.bottomAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 90).isActive = false
        } else {
            
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = false
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 271).isActive = true
            
            margins.bottomAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 90).isActive = true
            margins.bottomAnchor.constraint(equalTo: enterButton.bottomAnchor, constant: 40).isActive = false
        }
    }
    
    
    
    

}

