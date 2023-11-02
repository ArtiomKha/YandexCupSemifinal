//
//  ViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class SoundMakerContainerController: UIViewController {

    private let soundControlController = SoundControlViewController()
    private let audioPlayerController = AudioPlayerViewController()
    private let samplesListController = SamplesListViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildren()
    }

    private func setupChildren() {
        
        addChild(soundControlController)
        view.addSubview(soundControlController.view)
        soundControlController.view.translatesAutoresizingMaskIntoConstraints = false
        soundControlController.didMove(toParent: self)
        
        addChild(audioPlayerController)
        view.addSubview(audioPlayerController.view)
        audioPlayerController.view.translatesAutoresizingMaskIntoConstraints = false
        audioPlayerController.didMove(toParent: self)
        audioPlayerController.delegate = self

        NSLayoutConstraint.activate([
            audioPlayerController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            audioPlayerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            audioPlayerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            audioPlayerController.view.heightAnchor.constraint(equalToConstant: 105)
        ])

        NSLayoutConstraint.activate([
            soundControlController.view.topAnchor.constraint(equalTo: view.topAnchor),
            soundControlController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            soundControlController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            soundControlController.view.bottomAnchor.constraint(equalTo: audioPlayerController.view.topAnchor)
        ])
    }

    func presentSamplesListController() {
        if samplesListController.parent == nil {
            addSamplesListController()
        } else {
            dismissSamplesList()
        }
    }

    func dismissSamplesList() {
        samplesListController.willMove(toParent: nil)
        samplesListController.view.removeFromSuperview()
        samplesListController.view.removeConstraints(samplesListController.view.constraints)
        samplesListController.removeFromParent()
    }

    private func addSamplesListController() {
        addChild(samplesListController)
        view.addSubview(samplesListController.view)
        samplesListController.view.translatesAutoresizingMaskIntoConstraints = false
        samplesListController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            samplesListController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            samplesListController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            samplesListController.view.bottomAnchor.constraint(equalTo: audioPlayerController.view.topAnchor, constant: 17),
            samplesListController.view.heightAnchor.constraint(equalToConstant: samplesListController.contentHeight())
        ])
    }

    //private func calculateSoundControl
}

