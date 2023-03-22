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
    

}
