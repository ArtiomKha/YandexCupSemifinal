//
//  SoundMakerContainer+Delegates.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

extension SoundMakerContainerController: AudioPlayerControllerDelegate {

    func didTapSamplesButton() {
        presentSamplesListController()
    }

    func didTapPlayButton() {
        guard !samples.isEmpty else { return }
        if audioBuilder.isPlaying {
            audioBuilder.pause()
        } else {
            audioPlayerController.resetSoundwave()
            audioBuilder.buildAudioAndPlay(from: samples)
        }
        audioPlayerController.updatePlayButton(isPlaying: audioBuilder.isPlaying)
        soundControlController.prepareForRecording(isRecording: audioBuilder.isPlaying)
    }

    func didTapRecordButton() {
        guard !samples.isEmpty else { return }
        if audioBuilder.isRecording {
            if let url = audioBuilder.stopRecording() {
                shareFile(url)
            }
        } else {
            audioPlayerController.resetSoundwave()
            audioBuilder.buildAudioAndRecord(from: samples)
        }
        audioPlayerController.updateRecordButton(isRecording: audioBuilder.isRecording)
        soundControlController.prepareForRecording(isRecording: audioBuilder.isRecording)
    }

    func didTapMicButton() {
        audioRecorder.checkAuthorisation { [weak self] isAuthorised in
            guard let self else { return }
            DispatchQueue.main.async {
                if isAuthorised {
                    self.performMicRecord()
                } else {
                    self.presentSettingsAlert()
                }
            }
        }
    }

    private func performMicRecord() {
        audioPlayerController.updateMicButton(isRecording: !audioRecorder.isRecording)
        soundControlController.prepareForRecording(isRecording: !audioRecorder.isRecording)
        if audioRecorder.isRecording {
            if let url = audioRecorder.stopRecording() {
                addAudioRecordingSample(with: url)
            }
        } else {
            audioRecorder.startRecording()
        }
    }

    private func addAudioRecordingSample(with url: URL) {
        let audioNumber = samples.filter { $0.filename.isAudioRecoridng }.count + 1
        samples.append(.init(url: url, name: "Запись \(audioNumber)", id: ConfigurableSamplesIDGenerator.generateNewId()))
        updateSamplesListDataSource()
    }

    func didSelectFileType(_ type: FileType) {
        audioBuilder.setFileType(type)
    }
}

extension SoundMakerContainerController: AudioBuilderDelegate {

    func didReceiveBuffer(size: CGFloat) {
        DispatchQueue.main.async {
            self.audioPlayerController.populateSoundwave(size)
        }
    }

}
