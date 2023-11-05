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
        button.tintColor = .black
        button.setAttributedTitle(NSAttributedString(string: "Слои", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular)]), for: .normal)
        button.setImage(.chevronTop, for: .normal)
        return button
    }()

    let fileTypeButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.titleAlignment = .leading
        configuration.contentInsets = .init(top: 10, leading: 5, bottom: 10, trailing: 5)
        button.configuration = configuration
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.black, for: .disabled)
        button.setTitleColor(.black, for: .selected)
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        button.tintColor = .black
        button.setAttributedTitle(NSAttributedString(string: "Слои", attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular)]), for: .normal)
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

    let fileTypePickerView: FIleTypePickerView = {
        let view = FIleTypePickerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
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
        addSubview(fileTypePickerView)
        buttonsStackView.addArrangedSubview(layersButton)
        buttonsStackView.addArrangedSubview(fileTypeButton)
        bringSubviewToFront(fileTypePickerView)
        _ = buttonsStackView.addArrangedSpacerView()
        [timerLabel, micButton, recordButton, playButton].forEach { buttonsStackView.addArrangedSubview($0) }
        buttonsStackView.setCustomSpacing(10, after: timerLabel)
        setupConstraints()
        fileTypeButton.addTarget(self, action: #selector(didTapFileType), for: .primaryActionTriggered)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            soundWaveView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            soundWaveView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            soundWaveView.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            soundWaveView.heightAnchor.constraint(equalToConstant: 35),
            
            fileTypePickerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            fileTypePickerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            fileTypePickerView.centerYAnchor.constraint(equalTo: soundWaveView.centerYAnchor),
            fileTypePickerView.heightAnchor.constraint(equalToConstant: 34),
            fileTypeButton.widthAnchor.constraint(equalToConstant: calculateFileTypeButtonWidth()),
            
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
        soundWaveView.alpha = isExpanded ? 0 : 1
        fileTypeButton.isUserInteractionEnabled = !isExpanded
        fileTypeButton.alpha = isExpanded ? 0.3 : 1
    }

    func updatePlayButton(isPlaying: Bool) {
        playButton.setImage(isPlaying ? .pause : .play, for: .normal)
        recordButton.isEnabled = !isPlaying
        micButton.isUserInteractionEnabled = !isPlaying
        layersButton.isUserInteractionEnabled = !isPlaying
        recordButton.alpha = isPlaying ? 0.3 : 1
        micButton.alpha = isPlaying ? 0.3 : 1
        layersButton.alpha = isPlaying ? 0.3 : 1
        fileTypeButton.isUserInteractionEnabled = !isPlaying
        fileTypeButton.alpha = isPlaying ? 0.3 : 1
    }

    func updateRecordButton(isRecording: Bool) {
        recordButton.setImage(isRecording ? .activeRecord : .record, for: .normal)
        playButton.isEnabled = !isRecording
        micButton.isUserInteractionEnabled = !isRecording
        layersButton.isUserInteractionEnabled = !isRecording
        playButton.alpha = isRecording ? 0.3 : 1
        micButton.alpha = isRecording ? 0.3 : 1
        layersButton.alpha = isRecording ? 0.3 : 1
        fileTypeButton.isUserInteractionEnabled = !isRecording
        fileTypeButton.alpha = isRecording ? 0.3 : 1
    }

    func updateMicButton(isRecording: Bool) {
        micButton.tintColor = isRecording ? Colors.acidRed : Colors.darkGray
        playButton.isEnabled = !isRecording
        recordButton.isEnabled = !isRecording
        layersButton.isUserInteractionEnabled = !isRecording
        playButton.alpha = isRecording ? 0.3 : 1
        recordButton.alpha = isRecording ? 0.3 : 1
        layersButton.alpha = isRecording ? 0.3 : 1
        fileTypeButton.isUserInteractionEnabled = !isRecording
        fileTypeButton.alpha = isRecording ? 0.3 : 1
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

    func setFileType(_ type: FileType) {
        fileTypeButton.setAttributedTitle(NSAttributedString(string: type.humanReadable, attributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular)]), for: .normal)
        fileTypePickerView.set(type)
    }

    @objc func didTapFileType() {
        fileTypePickerView.isHidden.toggle()
        let isOn = !fileTypePickerView.isHidden
        soundWaveView.isHidden = isOn
        fileTypeButton.backgroundColor = isOn ? Colors.acidGreen : .white
        playButton.isEnabled = !isOn
        micButton.isUserInteractionEnabled = !isOn
        layersButton.isUserInteractionEnabled = !isOn
        playButton.alpha = isOn ? 0.3 : 1
        micButton.alpha = isOn ? 0.3 : 1
        layersButton.alpha = isOn ? 0.3 : 1
        recordButton.isEnabled = !isOn
        recordButton.alpha = isOn ? 0.3 : 1
    }

    func calculateFileTypeButtonWidth() -> CGFloat {
        var max: CGFloat = 0
        for fileType in FileType.allCases {
            let width = (fileType.humanReadable as NSString).size(withAttributes: [.font : UIFont.systemFont(ofSize: 14, weight: .regular)]).width + 14
            if width > max {
                max = width
            }
        }
        return max
    }
}
