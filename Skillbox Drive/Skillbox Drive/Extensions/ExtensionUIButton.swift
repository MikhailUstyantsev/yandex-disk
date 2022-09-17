

import Foundation
import UIKit

extension UIButton {
    static func customButton(title: String, backgroundColor: UIColor, titleColor: UIColor, fontSize: CGFloat, radius: CGFloat) -> UIButton {
          let button = UIButton (type: .custom)
          button.setTitle(title, for: .normal)
          button.translatesAutoresizingMaskIntoConstraints = false
          button.backgroundColor = backgroundColor
          button.setTitleColor(titleColor, for: .normal)
          button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
          button.layer.cornerRadius = radius
          return button
      }
}
