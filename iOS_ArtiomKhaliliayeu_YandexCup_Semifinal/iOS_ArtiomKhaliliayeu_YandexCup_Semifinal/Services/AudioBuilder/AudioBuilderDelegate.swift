//
//  AudioBuilderDelegate.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/5/23.
//

import Foundation

protocol AudioBuilderDelegate: AnyObject {
    func didReceiveBuffer(size: CGFloat)
}
