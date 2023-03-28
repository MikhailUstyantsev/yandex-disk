//
//  UIAlertController+Extensions.swift
//  TabBarProgrammatically
//
//  Created by Mikhail Ustyantsev on 25.02.2023.
//

import UIKit

extension UIViewController {
    
    func presentUnknownFileAlert(title: String = "К сожалению данный формат пока не поддерживается", message: String? = "Мы работаем над этим", buttonTitle: String = "OK", action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    func presentRenameAlert(title: String = "Переименовать", message: String? = "Введите новое имя файла", buttonTitle: String = "Готово", name: String, action: @escaping (String) -> Void) {
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
    
    func presentDeleteAlert(title: String = "Удалить объект?", message: String? = nil, buttonTitle: String = "Удалить", action: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alertController.addAction(UIAlertAction(title: buttonTitle, style: .destructive, handler: { _ in
            action()
        }))
        present(alertController, animated: true)
    }
    
    func presentShareAlert(title: String = "Поделиться", message: String? = nil, action1: @escaping () -> Void, action2: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Файлом", style: .default, handler: { _ in
            action1()
        }))
        alertController.addAction(UIAlertAction(title: "Ссылкой", style: .default, handler: { _ in
            action2()
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
    
    func showDeleteLabel(_ deleteLabel: UILabel) {
        deleteLabel.textColor = .label
        deleteLabel.backgroundColor = .secondarySystemBackground
        deleteLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        deleteLabel.clipsToBounds = true
        deleteLabel.layer.cornerRadius = 5
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        deleteLabel.textAlignment = .center
        deleteLabel.text = "Удаляется..."
        view.addSubview(deleteLabel)
        NSLayoutConstraint.activate([
            deleteLabel.widthAnchor.constraint(equalToConstant: view.bounds.size.width - 130),
            deleteLabel.heightAnchor.constraint(equalToConstant: 35),
            deleteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
              ])
    }
    
    
    func removeDeleteLabel(_ deleteLabel: UILabel) {
        DispatchQueue.main.async {
            deleteLabel.translatesAutoresizingMaskIntoConstraints = false
            deleteLabel.removeFromSuperview()
        }
    }
    
    func showNoConnectionLabel(_ label: UILabel) {
        label.textColor = .label
        label.numberOfLines = 2
        label.backgroundColor = .systemRed
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Отсутствует подключение к интернету"
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 40),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
              ])
    }
    
    func removeNoConnectionLabel(_ label: UILabel) {
        DispatchQueue.main.async {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.removeFromSuperview()
        }
    }
    
    func showNoFilesLabel() {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 3
        label.backgroundColor = .systemBackground
        label.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        label.clipsToBounds = true
        label.layer.cornerRadius = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Директория не содержит файлов"
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalTo: view.widthAnchor),
            label.heightAnchor.constraint(equalToConstant: 300),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
              ])
    }
    
}
