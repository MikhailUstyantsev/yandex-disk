//
//  UIButton + Extensions.swift
//  Skillbox Drive
//
//  Created by Mikhail Ustyantsev on 06.03.2023.
//

import UIKit

extension UIButton {
    static func customButton(title: String, backgroundColor: UIColor = .systemBackground, titleColor: UIColor = .label, fontSize: CGFloat, radius: CGFloat) -> UIButton {
        let button = UIButton (type: .system)
        button.setTitle(title, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = radius
        button.backgroundColor = backgroundColor
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        return button
    }
    
    static func systemRenameButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func systemShareButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func systemDeleteButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "trash"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
