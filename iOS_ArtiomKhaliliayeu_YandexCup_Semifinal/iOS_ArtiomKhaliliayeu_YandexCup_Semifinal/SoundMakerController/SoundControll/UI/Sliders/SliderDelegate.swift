//
//  SliderDelegate.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

protocol SliderDelegate: AnyObject {
    func didFinish(slider: UIView)
    func valueChanged(slider: UIView, with value: Double)
}
