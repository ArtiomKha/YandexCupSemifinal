//
//  SoundPickerCellView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/31/23.
//

import UIKit

class SoundPickerCellView: UIView {

    private let imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()

    var isEnabled: Bool = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.alpha = self.isEnabled ? 1 : 0.3
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .white
        addSubview(imageView)
    }

    func set(type: SoundTypes) {
        imageView.image = type.icon
        NSLayoutConstraint.deactivate(imageView.constraints)
        var imageConstraints = [
            imageView.widthAnchor.constraint(equalToConstant: type.iconSize.width),
            imageView.heightAnchor.constraint(equalToConstant: type.iconSize.height),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        if type.isImageCentered {
            imageConstraints.append(imageView.centerYAnchor.constraint(equalTo: centerYAnchor))
        } else {
            imageConstraints.append(imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5))
        }
        NSLayoutConstraint.activate(imageConstraints)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
