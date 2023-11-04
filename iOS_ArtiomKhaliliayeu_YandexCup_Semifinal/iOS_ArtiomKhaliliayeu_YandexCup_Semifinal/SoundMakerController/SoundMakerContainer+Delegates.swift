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
        if audioBuilder.isPlaying {
            audioBuilder.pause()
        } else {
            audioBuilder.buildAudioAndPlay(from: samples)
        }
        audioPlayerController.updatePlayButton(isPlaying: audioBuilder.isPlaying)
        soundControlController.prepareForRecording(isRecording: audioBuilder.isPlaying)
    }

    func didTapRecordButton() {
        //TODO: - вроде бы лагает конец записи
        if audioBuilder.isRecording {
            if let url = audioBuilder.stopRecording() {
                DispatchQueue.main.async {
                    self.shareFile(url)
                }
            }
        } else {
            audioBuilder.buildAudioAndRecord(from: samples)
        }
        audioPlayerController.updateRecordButton(isRecording: audioBuilder.isRecording)
        soundControlController.prepareForRecording(isRecording: audioBuilder.isRecording)
    }
}
