//
//  SoundPickerViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class SoundPickerViewController: UIViewController {

    private let soundProvider: SoundProviding = SoundProvider()
    private var soundTypes = [SoundTypes]()

    var rootView: SoundPickerView {
        view as! SoundPickerView
    }

    var bottomAnchor: NSLayoutYAxisAnchor {
        rootView.bottomAnchor
    }
    
    override func loadView() {
        view = SoundPickerView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        rootView.delegate = self
        soundTypes = soundProvider.getSoundTypes()
        rootView.set(soundTypes: soundTypes)
    }
    
}

extension SoundPickerViewController: SoundPickerViewDelegate {
    func didTapOnSound(with id: Int) {

    }
    
    func didLongTapOnSound(with id: Int) {
        guard let type = soundTypes.first(where: { $0.id == id }) else { return }
        rootView.displayExpandedView(for: soundProvider.getSamplesFor(type: type))
    }
    
    func didSelectedSample(for soundId: Int, _ sampleId: Int) {
        print(soundId, sampleId)
    }

    //TODO: - remove
    func didTapOnBackground() {

    }
}
