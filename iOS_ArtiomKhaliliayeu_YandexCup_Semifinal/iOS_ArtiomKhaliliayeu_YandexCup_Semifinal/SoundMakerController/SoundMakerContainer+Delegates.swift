//
//  SoundMakerContainer+Delegates.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

extension SoundMakerContainerController: AudioPlayerControllerDelegate {

    func didTapSamplesButton() {
        presentSamplesListController()
    }
}
