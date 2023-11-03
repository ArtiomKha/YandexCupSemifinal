//
//  SoundProvider.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import Foundation
import AVFoundation

protocol SoundProviding {
    func getSoundTypes() -> [SoundTypes]
    func getSamplesFor(type: SoundTypes) -> [SoundSample]
}

struct SoundProvider: SoundProviding {

    func getSoundTypes() -> [SoundTypes] {
        SoundTypes.allCases
    }

    func getSamplesFor(type: SoundTypes) -> [SoundSample] {
        type.samples
    }

}
