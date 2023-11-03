//
//  SoundPickerViewControllerDelegate.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/3/23.
//

import Foundation

protocol SoundPickerViewControllerDelegate: AnyObject {
    func didSelect(sample: SoundSample)
}
