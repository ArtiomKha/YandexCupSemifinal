//
//  SoundControlViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class SoundControlViewController: UIViewController {

    private let soundPickerController = SoundPickerViewController()

    var rootView: SoundControlView {
        view as! SoundControlView
    }

    override func loadView() {
        view = SoundControlView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChild()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.applyGradient()
    }

    func setupChild() {
        addChild(soundPickerController)
        view.addSubview(soundPickerController.view)
        soundPickerController.view.translatesAutoresizingMaskIntoConstraints = false
        soundPickerController.didMove(toParent: self)
        NSLayoutConstraint.activate([
            soundPickerController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            soundPickerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            soundPickerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            soundPickerController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        rootView.updateSliderPositions()
    }
}

extension SoundControlViewController: SoundControlViewDelegate {

    func didUpdateSound(_ value: Double) {
        
    }

    func didUpdateSpeed(_ value: Double) {
        
    }
}
