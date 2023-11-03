//
//  ConfigurableSamplesIDGenerator.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/3/23.
//

import Foundation

class ConfigurableSamplesIDGenerator {
    private static var id: Int = 0

    static func generateNewId() -> Int {
        id += 1
        return id
    }
}
