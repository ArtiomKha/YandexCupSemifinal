//
//  AudioPlayerViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class AudioPlayerViewController: UIViewController {

    weak var delegate: AudioPlayerControllerDelegate?

    var rootView: AudioPlayerView {
        view as! AudioPlayerView
    }

    override func loadView() {
        view = AudioPlayerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    func setupActions() {
        rootView.layersButton.addTarget(self, action: #selector(didtapLayersButton), for: .primaryActionTriggered)
        rootView.playButton.addTarget(self, action: #selector(playAudio), for: .primaryActionTriggered)
        rootView.recordButton.addTarget(self, action: #selector(didTapRecordButton), for: .primaryActionTriggered)
    }

    @objc private func didtapLayersButton() {
        delegate?.didTapSamplesButton()
    }

    func updateLayerButtonState(isExpanded: Bool) {
        rootView.updateLayersButton(isExpanded: isExpanded)
    }

    @objc func playAudio() {
        delegate?.didTapPlayButton()
    }

    func updatePlayButton(isPlaying: Bool) {
        rootView.updatePlayButton(isPlaying: isPlaying)
    }

    @objc func didTapRecordButton() {
        delegate?.didTapRecordButton()
    }

    func updateRecordButton(isRecording: Bool) {
        rootView.updateRecordButton(isRecording: isRecording)
    }
}
