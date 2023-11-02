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
        [
            .init(id: 1, filename: "", soundType: type),
            .init(id: 2, filename: "", soundType: type),
            .init(id: 3, filename: "", soundType: type)
        ]
    }

}
