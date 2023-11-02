//
//  SoundTypes.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

enum SoundTypes: Int, CaseIterable {
    case guitar = 0
    case drums = 1
    case winds = 2

    var id: Int {
        rawValue
    }

    var humanReadable: String {
        switch self {
        case .guitar:
            "гитара"
        case .drums:
            "ударные"
        case .winds:
            "духовые"
        }
    }

    var sampleFileNames: [String] {
        switch self {
        case .guitar:
            ["guitar1", "guitar2", "guitar3"]
        case .drums:
            ["drums1", "drums2", "drums3"]
        case .winds:
            ["winds1", "winds2", "winds3"]
        }
    }

    var icon: UIImage {
        switch self {
        case .guitar:
            UIImage(resource: .guitar)
        case .drums:
            UIImage(resource: .drums)
        case .winds:
            UIImage(resource: .winds)
        }
    }

    var iconSize: CGSize {
        switch self {
        case .guitar:
            CGSize(width: 27, height: 50)
        case .drums:
            CGSize(width: 34, height: 26)
        case .winds:
            CGSize(width: 44, height: 23)
        }
    }

    var isImageCentered: Bool {
        switch self {
        case .guitar:
            false
        default:
            true
        }
    }

}
