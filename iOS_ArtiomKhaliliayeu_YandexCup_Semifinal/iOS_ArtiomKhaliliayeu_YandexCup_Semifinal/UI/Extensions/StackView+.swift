//
//  StackView+.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/1/23.
//

import UIKit

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }

    private func createSpacerView() -> UIView {
        let view = UIView()
        view.setContentHuggingPriority(.init(1), for: self.axis)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func addArrangedSpacerView() -> UIView {
        let spacerView = createSpacerView()
        addArrangedSubview(spacerView)
        return spacerView
    }
}
