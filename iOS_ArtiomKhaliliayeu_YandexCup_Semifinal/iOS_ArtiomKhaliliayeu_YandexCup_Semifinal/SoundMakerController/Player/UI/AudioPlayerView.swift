//
//  AudioPlayerView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class AudioPlayerView: UIView {

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 15, bottom: 15, trailing: 15)
        return stackView
    }()

    let layersButton: UIButton = {
       let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.titleAlignment = .leading
        configuration.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        configuration.imagePadding = 16
        configuration.imagePlacement = .trailing
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.setTitle("Слои", for: .normal)
        button.setImage(.chevronTop, for: .normal)
        return button
    }()

    let playButton: RoundedIconButton = {
        let button = RoundedIconButton()
        button.setImage(.play, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let recordButton: RoundedIconButton = {
        let button = RoundedIconButton()
        button.setImage(.record, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let micButton: RoundedIconButton = {
        let button = RoundedIconButton()
        button.setImage(.microphone, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .black
        addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(layersButton)
        _ = buttonsStackView.addArrangedSpacerView()
        [micButton, recordButton, playButton].forEach { buttonsStackView.addArrangedSubview($0) }
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 59),
            layersButton.heightAnchor.constraint(equalToConstant: 34)
        ])
        [micButton, recordButton, playButton].forEach { button in
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: 34),
                button.widthAnchor.constraint(equalToConstant: 34)
            ])
        }
    }

    func updateLayersButton(isExpanded: Bool) {
        layersButton.backgroundColor = isExpanded ? .acidGreen : .white
        layersButton.setImage(isExpanded ? .chevronDown : .chevronTop, for: .normal)
    }
}
