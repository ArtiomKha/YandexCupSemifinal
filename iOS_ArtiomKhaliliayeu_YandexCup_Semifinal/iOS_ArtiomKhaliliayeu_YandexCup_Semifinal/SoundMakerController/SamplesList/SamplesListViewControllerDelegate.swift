//
//  SamplesListViewControllerDelegate.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/3/23.
//

import Foundation

protocol SamplesListViewControllerDelegate: AnyObject {
    func didToggleSound(for sampleId: Int, value: Bool)
    func didRemoveSample(with id: Int)
    func didSelectSample(wirh id: Int?)
}
