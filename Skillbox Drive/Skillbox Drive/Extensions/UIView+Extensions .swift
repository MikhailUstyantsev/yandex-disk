//
//  UIView+Extensions .swift
//  RickAndMortyApp
//
//  Created by Mikhail Ustyantsev on 14.02.2023.
//

import UIKit

extension UIView {
    
    func createDefaultShadow(for myView: UIView, cornerRadius: CGFloat) {
        myView.layer.shadowColor = UIColor.gray.cgColor
        //  shadowOffset задает направление и сдвиг тени по осям координат. По гайдам Apple тени должны быть направлены вертикально вниз, а мы помним, что в iOS перевернутая система координат, поэтому по дефолту она направлена вверх. Тип CGSize.
        myView.layer.shadowOffset = CGSize(width: 2, height: 5)
        //  shadowOpacity – свойство, управляющее видимостью тени. Принимает значения от 0 до 1 (по дефолту 0). Если мы установим значение, отличное от 0, то увидим небольшую тень, направленную вверх (система координат в iOS же перевернутая).
        myView.layer.shadowOpacity = 0.5
        //  shadowRadius  – это свойство контролирует размытость тени. Чем больше это значение, тем сильнее размытие.
        myView.layer.shadowRadius = 4.0
        myView.layer.cornerRadius = cornerRadius
        myView.clipsToBounds = false
        myView.layer.masksToBounds = false
    }
    
    func addSubviews(_ views: UIView...) {
            views.forEach { view in
                self.addSubview(view)
            }
        }
    
    enum Edge {
        case left
        case top
        case right
        case bottom
    }
    
    func pinToSuperviewEdges(_ edges: [Edge] = [.top, .bottom, .left, .right], constant: CGFloat = 0) {
        guard let superview = superview else { return }
        edges.forEach {
            switch $0 {
            case .top: topAnchor.constraint(equalTo: superview.topAnchor, constant: constant).isActive = true
            case .left:
                leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: constant).isActive = true
            case .right:
                trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -constant).isActive = true
            case .bottom:
                bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -constant).isActive = true
            }
        }
    }
    
}
