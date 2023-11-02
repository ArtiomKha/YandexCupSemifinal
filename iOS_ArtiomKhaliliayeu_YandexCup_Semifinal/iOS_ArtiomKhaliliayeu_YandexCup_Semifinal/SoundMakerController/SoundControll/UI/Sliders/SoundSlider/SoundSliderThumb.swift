//
//  SoundSliderThumb.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

class SoundControlSliderThumb: UIView {

    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 11)
        label.text = "громкость"
        return label
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        addSubview(label)
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        backgroundColor = Colors.acidGreen
        layer.cornerRadius = 4
    }

    func getLabelWidth() -> CGFloat {
        let text = label.text ?? ""
        return (text as NSString).size(withAttributes: [.font : UIFont.systemFont(ofSize: 12)]).width
    }
}
