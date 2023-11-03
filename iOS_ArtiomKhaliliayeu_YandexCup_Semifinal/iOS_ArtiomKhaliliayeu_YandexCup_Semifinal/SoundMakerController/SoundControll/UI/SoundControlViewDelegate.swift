//
//  SoundControlViewDelegate.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

protocol SoundControlViewDelegate: AnyObject {
    func didUpdateSpeed(_ value: Double)
    func didUpdateSound(_ value: Double)
    func didFinishSlider(_ slider: UIView)
}
