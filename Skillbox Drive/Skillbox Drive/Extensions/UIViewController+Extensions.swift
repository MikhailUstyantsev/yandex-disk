//
//  UIAlertController+Extensions.swift
//  TabBarProgrammatically
//
//  Created by Mikhail Ustyantsev on 25.02.2023.
//

import UIKit

extension UIViewController {
    
    func showDefaultAlert(title: String = "К сожалению данный формат пока не поддерживается", message: String? = "Мы работаем над этим", buttonTitle: String = "OK", action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    func showRenameAlert(title: String = "Переименовать", message: String? = "Введите новое имя файла", buttonTitle: String = "Готово", name: String, action: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { textfield in
            textfield.text = name
        }
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            if let newName = alertController.textFields?[0].text {
                action(newName)
            }
          
        }))
        present(alertController, animated: true)
    }
    
    func showRenamingLabel(_ renamingLabel: UILabel) {
        renamingLabel.textColor = .label
        renamingLabel.backgroundColor = .secondarySystemBackground
        renamingLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        renamingLabel.clipsToBounds = true
        renamingLabel.layer.cornerRadius = 5
        renamingLabel.translatesAutoresizingMaskIntoConstraints = false
        renamingLabel.textAlignment = .center
        renamingLabel.text = "Переименовывается..."
        view.addSubview(renamingLabel)
        NSLayoutConstraint.activate([
            renamingLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width - 130),
            renamingLabel.heightAnchor.constraint(equalToConstant: 35),
            renamingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            renamingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
              ])
    }
    
    func removeRenamingLabel(_ renamingLabel: UILabel) {
        DispatchQueue.main.async {
            renamingLabel.translatesAutoresizingMaskIntoConstraints = false
            renamingLabel.removeFromSuperview()
        }
    }
    
}
