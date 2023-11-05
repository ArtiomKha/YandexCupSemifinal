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
        button.setTitleColor(.black, for: .disabled)
        button.setTitleColor(.black, for: .selected)
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
        button.setImage(.microphone.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = Colors.darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = Colors.grayBackground
        label.isHidden = true
        return label
    }()

    private let soundWaveView: SoundwaveView = {
        let view = SoundwaveView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(soundWaveView)
        buttonsStackView.addArrangedSubview(layersButton)
        _ = buttonsStackView.addArrangedSpacerView()
        [timerLabel, micButton, recordButton, playButton].forEach { buttonsStackView.addArrangedSubview($0) }
        buttonsStackView.setCustomSpacing(10, after: timerLabel)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            soundWaveView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            soundWaveView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            soundWaveView.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            soundWaveView.heightAnchor.constraint(equalToConstant: 35),
            
            buttonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 59),
            layersButton.heightAnchor.constraint(equalToConstant: 34),
            timerLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 40)
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
        recordButton.isEnabled = !isExpanded
        micButton.isUserInteractionEnabled = !isExpanded
        playButton.isEnabled = !isExpanded
        recordButton.alpha = isExpanded ? 0.3 : 1
        micButton.alpha = isExpanded ? 0.3 : 1
        playButton.alpha = isExpanded ? 0.3 : 1
    }

    func updatePlayButton(isPlaying: Bool) {
        playButton.setImage(isPlaying ? .pause : .play, for: .normal)
        recordButton.isEnabled = !isPlaying
        micButton.isUserInteractionEnabled = !isPlaying
        layersButton.isEnabled = !isPlaying
        recordButton.alpha = isPlaying ? 0.3 : 1
        micButton.alpha = isPlaying ? 0.3 : 1
        layersButton.alpha = isPlaying ? 0.3 : 1
    }

    func updateRecordButton(isRecording: Bool) {
        recordButton.setImage(isRecording ? .activeRecord : .record, for: .normal)
        playButton.isEnabled = !isRecording
        micButton.isUserInteractionEnabled = !isRecording
        layersButton.isEnabled = !isRecording
        playButton.alpha = isRecording ? 0.3 : 1
        micButton.alpha = isRecording ? 0.3 : 1
        layersButton.alpha = isRecording ? 0.3 : 1
    }

    func updateMicButton(isRecording: Bool) {
        micButton.tintColor = isRecording ? Colors.acidRed : Colors.darkGray
        playButton.isEnabled = !isRecording
        recordButton.isEnabled = !isRecording
        layersButton.isEnabled = !isRecording
        playButton.alpha = isRecording ? 0.3 : 1
        recordButton.alpha = isRecording ? 0.3 : 1
        layersButton.alpha = isRecording ? 0.3 : 1
    }

    func showTimerLabel(_ show: Bool) {
        timerLabel.isHidden = !show
    }

    func updateTimerLabelValue(_ value: String) {
        timerLabel.text = value
    }

    func populateSoundwave(_ frame: CGFloat) {
        soundWaveView.addNewFrame(frame)
    }

    func resetSoundwave() {
        soundWaveView.clear()
    }
}
