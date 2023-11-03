//
//  SampleCellView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

class SampleCellView: UICollectionViewCell {

    static let identifier = "SampleCellView"

    var closeButtonAction: (() -> Void)?
    var playButtonAction: (() -> Void)?
    var soundButtonAction: (() -> Void)?

    private let backgroundContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 4
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.play, for: .normal)
        return button
    }()
    
    private let soundButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.soundOn, for: .normal)
        return button
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.close, for: .normal)
        button.backgroundColor = Colors.grayBackground
        button.layer.cornerRadius = 4
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        contentView.addSubview(backgroundContentView)
        [titleLabel, soundButton, playButton, deleteButton].forEach { backgroundContentView.addSubview($0) }
        NSLayoutConstraint.activate([
            backgroundContentView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            backgroundContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: backgroundContentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundContentView.leadingAnchor, constant: 10),
            deleteButton.trailingAnchor.constraint(equalTo: backgroundContentView.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: backgroundContentView.topAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: backgroundContentView.bottomAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 39),
            soundButton.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -6),
            soundButton.topAnchor.constraint(equalTo: backgroundContentView.topAnchor),
            soundButton.bottomAnchor.constraint(equalTo: backgroundContentView.bottomAnchor),
            soundButton.widthAnchor.constraint(equalToConstant: 29),
            playButton.trailingAnchor.constraint(equalTo: soundButton.leadingAnchor, constant: -6),
            playButton.topAnchor.constraint(equalTo: backgroundContentView.topAnchor),
            playButton.bottomAnchor.constraint(equalTo: backgroundContentView.bottomAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 29),
        ])
        deleteButton.addTarget(self, action: #selector(didTapCloseButton), for: .primaryActionTriggered)
        playButton.addTarget(self, action: #selector(didTapPlayButton), for: .primaryActionTriggered)
        soundButton.addTarget(self, action: #selector(didTapSoundButton), for: .primaryActionTriggered)
    }

    func set(_ model: SampleViewCellModel) {
        titleLabel.text = model.sampleName
        soundButton.setImage(model.isSoundOn ? .soundOn : .soundOff, for: .normal)
        playButton.setImage(model.isPlaying ? .pause : .play, for: .normal)
        backgroundContentView.backgroundColor = model.isSelected ? .acidGreen : .white
    }

    @objc func didTapPlayButton() {
        playButtonAction?()
    }

    @objc func didTapSoundButton() {
        soundButtonAction?()
    }

    @objc func didTapCloseButton() {
        closeButtonAction?()
    }
}
