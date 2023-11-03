//
//  SamplesConfigurator.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/3/23.
//

import Foundation
import AVFoundation

class SamplesConfigurator {
    
    static let defaultSpeed: Double = 1
    static let defaultSound: Double = 0.5

    private (set) var currentlySelectedSample: ConfigurableSample?
    private var speed: Double = 1.0
    private var sound: Double = 1.0

    func setSample(_ sample: ConfigurableSample?) {
        currentlySelectedSample = sample
    }

    func createSample(_ sample: SoundSample) -> ConfigurableSample {
        let configurableSample = ConfigurableSample(sample: sample, id: ConfigurableSamplesIDGenerator.generateNewId(), volume: sound, speed: speed)
        currentlySelectedSample = configurableSample
        return configurableSample
    }

    func set(speed: Double) {
        self.speed = speed
        currentlySelectedSample?.speed = speed
    }

    func set(sound: Double) {
        self.sound = sound
        currentlySelectedSample?.volume = sound
    }
}
