//
//  ConfigurableSample.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/3/23.
//

import Foundation

struct ConfigurableSample {
    let name: String
    let filename: String
    var volume: Double
    var speed: Double
    var isOn: Bool = true
    var id: Int

    init(name: String, filename: String, volume: Double, speed: Double, isOn: Bool, id: Int) {
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
        self.filename = sample.filename
    }
}
