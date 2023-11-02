//
//  SoundPickerViewDelegate.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/31/23.
//

import Foundation

protocol SoundPickerViewDelegate: AnyObject {
    func didTapOnSound(with id: Int)
    func didLongTapOnSound(with id: Int)
    func didSelectedSample(for soundId: Int, _ sampleId: Int)
}
