//
//  RoundedIconButton.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/1/23.
//

import UIKit

class RoundedIconButton: UIButton {

    var imageInsets: NSDirectionalEdgeInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10) {
        didSet {
            self.configuration?.contentInsets = imageInsets
        }
    }

    init() {
        super.init(frame: .zero)
        configureImage()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureImage()
    }

    func configureImage() {
        var configuration = UIButton.Configuration.plain()
        self.configuration = configuration
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        backgroundColor = .white
        layer.cornerRadius = 4
    }
}
