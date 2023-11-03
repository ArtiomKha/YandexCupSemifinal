//
//  SoundPickerViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class SoundPickerViewController: UIViewController {

    //TODO: - Add DI
    weak var delegate: SoundPickerViewControllerDelegate?
    private let soundProvider: SoundProviding = SoundProvider()
    private let samplesPlayer: SamplesPlayer
    private var soundTypes = [SoundTypes]()
    private var lastSelectedSample: SoundSample?

    init(samplesPlayer: SamplesPlayer) {
        self.samplesPlayer = samplesPlayer
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

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
    
    func previewSoundType(for id: Int) {
        guard let soundType = soundTypes.first(where: { $0.id == id }), let sample = soundType.samples.first else { return }
        samplesPlayer.previewSoundType(soundType)
        delegate?.didSelect(sample: sample)
    }

    func previewSample(soundId: Int, sampleId: Int) {
        guard let soundType = soundTypes.first(where: { $0.id == soundId }), let sample = soundType.samples.first(where: { $0.id == sampleId }) else { return }
        lastSelectedSample = sample
        samplesPlayer.previewSample(sample)
    }
    
}

extension SoundPickerViewController: SoundPickerViewDelegate {
    func didTapOnSound(with id: Int) {
        previewSoundType(for: id)
        //TODO: - Pass to container
    }
    
    func didLongTapOnSound(with id: Int) {
        guard let type = soundTypes.first(where: { $0.id == id }) else { return }
        rootView.displayExpandedView(for: soundProvider.getSamplesFor(type: type))
    }
    
    func didSelectedSample(for soundId: Int, _ sampleId: Int) {
        previewSample(soundId: soundId, sampleId: sampleId)
    }

    func didFinishSamplesPreview() {
        samplesPlayer.stopPlayer()
        guard let lastSelectedSample else { return }
        delegate?.didSelect(sample: lastSelectedSample)
        self.lastSelectedSample = nil
    }
}
