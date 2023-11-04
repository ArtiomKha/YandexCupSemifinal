//
//  ConfigurableSample.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/3/23.
//

import Foundation

enum SampleFileType {
    case wav(String)
    case audioRecording(String)

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
        case .wav(let name), .audioRecording(let name):
            name
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
}
