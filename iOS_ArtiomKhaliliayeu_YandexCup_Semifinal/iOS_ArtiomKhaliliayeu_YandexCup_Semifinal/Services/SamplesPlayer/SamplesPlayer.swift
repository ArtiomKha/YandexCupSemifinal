//
//  SamplesPlayer.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/3/23.
//

import AVFoundation

protocol SamplesPlayerDelegate: AnyObject {
    func didFinishPlaying()
}

class SamplesPlayer: NSObject {

    weak var delegate: SamplesPlayerDelegate?
    var player: AVAudioPlayer?
    private var playerStopper: DispatchWorkItem?
    private var speed: Double = 1.0
    private var sound: Double = 1.0

    private func playSoundFrom(localFile: String, with fileType: String, for duration: Double?, loop: Bool = false) {
        if player?.isPlaying ?? false {
            player?.stop()
            playerStopper?.cancel()
        }
        guard let path = Bundle.main.path(forResource: localFile, ofType: fileType) else { return }
        let url = URL(fileURLWithPath: path)
        player = try? AVAudioPlayer(contentsOf: url)
        player?.delegate = self
        player?.enableRate = true
        player?.rate = Float(speed)
        player?.setVolume(Float(sound), fadeDuration: 0.1)

        if let duration {
            playerStopper = DispatchWorkItem(block: { [weak self] in
                self?.player?.stop()
                self?.delegate?.didFinishPlaying()
                print("Stopped")
            })
            guard let playerStopper else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: playerStopper)
        } else if loop {
            player?.numberOfLoops = -1
        }
        
        player?.play()
    }

    func previewSample(_ sample: SoundSample) {
        playSoundFrom(localFile: sample.filename, with: "wav", for: nil)
    }

    func previewSoundType(_ type: SoundTypes) {
        guard let filename = type.sampleFileNames.first else { return }
        playSoundFrom(localFile: filename, with: "wav", for: 5)
    }

    func stopPlayer() {
        player?.stop()
        delegate?.didFinishPlaying()
    }

    func set(speed: Double) {
        self.speed = speed
        player?.enableRate = true
        player?.rate = Float(speed)
    }

    func set(sound: Double) {
        self.sound = sound
        player?.setVolume(Float(sound), fadeDuration: 0.1)
    }

    func playFromFileInLoop(filename: SampleFileType) {
        if player?.isPlaying ?? false { return }
        playSoundFrom(localFile: filename.name, with: filename.fileExtension, for: nil, loop: true)
    }

    func playFullFromSound(filename: SampleFileType, with volume: Double, and speed: Double) {
        self.sound = volume
        self.speed = speed
        playSoundFrom(localFile: filename.name, with: filename.fileExtension, for: nil)
    }
}

extension SamplesPlayer: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        delegate?.didFinishPlaying()
    }
}
