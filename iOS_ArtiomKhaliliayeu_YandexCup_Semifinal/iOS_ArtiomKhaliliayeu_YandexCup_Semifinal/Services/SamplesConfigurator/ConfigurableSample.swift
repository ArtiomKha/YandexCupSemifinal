//
//  ConfigurableSample.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/3/23.
//

import Foundation

enum SampleFileType {
    case wav(String)
    case audioRecording(URL)

    var fileExtension: String {
        switch self {
        case .wav:
            "wav"
        case .audioRecording:
            ""
        }
    }

    var name: String {
        switch self {
        case .wav(let name):
            name
        case .audioRecording:
            ""
        }
    }

    var isAudioRecoridng: Bool {
        switch self {
        case .wav:
            false
        case .audioRecording:
            true
        }
    }
}

struct ConfigurableSample {
    let name: String
    let filename: SampleFileType
    var volume: Double
    var speed: Double
    var isOn: Bool = true
    var id: Int

    init(name: String, filename: SampleFileType, volume: Double, speed: Double, isOn: Bool, id: Int) {
        self.name = name
        self.filename = filename
        self.volume = volume
        self.speed = speed
        self.isOn = isOn
        self.id = id
    }

    init(sample: SoundSample, id: Int, volume: Double, speed: Double) {
        self.id = id
        self.name = sample.soundType.humanReadable + " \(sample.id)"
        self.volume = volume //TODO: - Update
        self.speed = speed //TODO: - Update
        self.isOn = true
        self.filename = .wav(sample.filename)
    }
    
    init(url: URL, name: String, id: Int) {
        self.name = name
        self.filename = .audioRecording(url)
        self.volume = 1
        self.speed = 1
        self.isOn = true
        self.id = id
    }
}
