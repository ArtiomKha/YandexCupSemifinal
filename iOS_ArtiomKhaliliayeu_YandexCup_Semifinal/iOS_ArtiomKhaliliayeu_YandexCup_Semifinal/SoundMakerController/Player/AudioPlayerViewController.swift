//
//  AudioPlayerViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class AudioPlayerViewController: UIViewController {

    weak var delegate: AudioPlayerControllerDelegate?
    private var micTimer: Timer?
    private var micDuration: Int = 0

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
        rootView.micButton.addTarget(self, action: #selector(didTapMicButton), for: .primaryActionTriggered)
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
        startTimer(isPlaying)
    }

    @objc func didTapRecordButton() {
        delegate?.didTapRecordButton()
    }

    func updateRecordButton(isRecording: Bool) {
        rootView.updateRecordButton(isRecording: isRecording)
        startTimer(isRecording)
    }

    @objc private func didTapMicButton() {
        delegate?.didTapMicButton()
    }

    func updateMicButton(isRecording: Bool) {
        rootView.updateMicButton(isRecording: isRecording)
        startTimer(isRecording)
    }

    func startTimer(_ start: Bool = true) {
        if start {
            micDuration = 0
            micTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(micTimerFired), userInfo: nil, repeats: true)
            rootView.showTimerLabel(true)
        } else {
            micTimer?.invalidate()
            micTimer = nil
            rootView.updateTimerLabelValue("")
            rootView.showTimerLabel(false)
            micDuration = 0
        }
    }
    
    @objc func micTimerFired() {
        micDuration += 1
        let minuntesAndSeconds = secondsToMinutesSeconds(micDuration)
        let secondsText = minuntesAndSeconds.1 > 9 ? "\(minuntesAndSeconds.1)" : "0\(minuntesAndSeconds.1)"
        rootView.updateTimerLabelValue("\(minuntesAndSeconds.0) : \(secondsText)")
    }

    private func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
        return ((seconds % 3600) / 60, (seconds % 3600) % 60)
    }

    func populateSoundwave(_ frame: CGFloat) {
        rootView.populateSoundwave(frame)
    }

    func resetSoundwave() {
        rootView.resetSoundwave()
    }
}
