//
//  SampleViewCellModel.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import Foundation

struct SampleViewCellModel {
    let id: Int
    let sampleName: String
    let filename: SampleFileType
    let sound: Double
    let speed: Double
    var isPlaying: Bool = false
    var isSoundOn: Bool = true
    var isSelected: Bool = false

    init(id: Int, sampleName: String, filename: SampleFileType, sound: Double, speed: Double, isPlaying: Bool, isSoundOn: Bool, isSelected: Bool) {
        self.id = id
        self.sampleName = sampleName
        self.filename = filename
        self.sound = sound
        self.speed = speed
        self.isPlaying = isPlaying
        self.isSoundOn = isSoundOn
        self.isSelected = isSelected
    }

    init(_ sample: ConfigurableSample, isSelected: Bool = false) {
        self.id = sample.id
        self.sampleName = sample.name
        self.filename = sample.filename
        self.sound = sample.volume
        self.speed = sample.speed
        self.isPlaying = false
        self.isSoundOn = sample.isOn
        self.isSelected = isSelected
    }
}
