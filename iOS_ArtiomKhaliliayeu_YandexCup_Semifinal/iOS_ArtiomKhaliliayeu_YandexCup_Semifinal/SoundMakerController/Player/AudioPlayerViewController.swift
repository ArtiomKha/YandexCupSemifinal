//
//  AudioPlayerViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class AudioPlayerViewController: UIViewController {

    weak var delegate: AudioPlayerControllerDelegate?

    var rootView: AudioPlayerView {
        view as! AudioPlayerView
    }

    override func loadView() {
        view = AudioPlayerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    func setupActions() {
        rootView.layersButton.addTarget(self, action: #selector(didtapLayersButton), for: .primaryActionTriggered)
    }

    @objc private func didtapLayersButton() {
        delegate?.didTapSamplesButton()
    }
}
