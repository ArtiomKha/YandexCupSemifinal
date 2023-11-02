//
//  SoundSample.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/31/23.
//

import Foundation

struct SoundSample {
    let id: Int
    let filename: String
    let soundType: SoundTypes

    var humanReadable: String {
       "сэмпл \(id)"
    }
}
