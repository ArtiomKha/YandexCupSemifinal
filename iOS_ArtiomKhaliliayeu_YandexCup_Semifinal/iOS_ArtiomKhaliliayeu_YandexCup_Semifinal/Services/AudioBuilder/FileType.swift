//
//  FileType.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/5/23.
//

import Foundation

enum FileType: Int, CaseIterable {
    case wav
    case aiff
    case m4a
    case caf

    var humanReadable: String {
        switch self {
        case .wav:
            "wav"
        case .aiff:
            "aiff"
        case .m4a:
            "m4a"
        case .caf:
            "caf"
        }
    }
}
