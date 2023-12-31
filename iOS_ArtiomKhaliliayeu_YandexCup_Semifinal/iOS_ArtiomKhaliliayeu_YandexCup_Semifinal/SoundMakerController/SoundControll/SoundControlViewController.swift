//
//  SoundControlViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class SoundControlViewController: UIViewController {

    weak var delegate: SoundControlViewControllerDelegate?

    private lazy var soundPickerController = SoundPickerViewController(samplesPlayer: samplesPlayer)
    //TODO: - Add DI
    private let samplesConfigurator: SamplesConfigurator
    private let samplesPlayer = SamplesPlayer()

    var rootView: SoundControlView {
        view as! SoundControlView
    }

    var contentViewHeight: CGFloat {
        rootView.contentView.bounds.height
    }
    
    init(samplesConfigurator: SamplesConfigurator) {
        self.samplesConfigurator = samplesConfigurator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("This class does not support NSCoder")
    }

    override func loadView() {
        view = SoundControlView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChild()
        rootView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rootView.applyGradient()
        setupDefaultConfiguration()
    }

    private func setupChild() {
        addChild(soundPickerController)
        view.addSubview(soundPickerController.view)
        soundPickerController.view.translatesAutoresizingMaskIntoConstraints = false
        soundPickerController.didMove(toParent: self)
        soundPickerController.delegate = self
        NSLayoutConstraint.activate([
            soundPickerController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            soundPickerController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            soundPickerController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            soundPickerController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        rootView.updateSliderPositions()
    }

    private func setupDefaultConfiguration() {
        rootView.setSound(value: SamplesConfigurator.defaultSound)
        rootView.setSpeed(value: SamplesConfigurator.defaultSpeed)
        samplesConfigurator.set(sound: SamplesConfigurator.defaultSound)
        samplesConfigurator.set(speed: SamplesConfigurator.defaultSpeed)
        samplesPlayer.set(sound: SamplesConfigurator.defaultSound)
        samplesPlayer.set(speed: SamplesConfigurator.defaultSpeed)
    }

    private func playCurrentlySelectedSample() {
        guard let filename = samplesConfigurator.currentlySelectedSample?.filename else { return }
        samplesPlayer.playFromFileInLoop(filename: filename)
    }

    func stopPlaying() {
        samplesPlayer.stopPlayer()
    }

    func prepareForSamplesList(isPresented: Bool) {
        rootView.hideSliders(isPresented)
        soundPickerController.view.isUserInteractionEnabled = !isPresented
        if isPresented {
            samplesPlayer.stopPlayer()
        }
    }

    func prepareForRecording(isRecording: Bool) {
        rootView.isUserInteractionEnabled = !isRecording
        soundPickerController.rootView.isUserInteractionEnabled = !isRecording
        if isRecording {
            samplesPlayer.stopPlayer()
        }
    }

    func updateThumbs(for sample: ConfigurableSample) {
        rootView.setSpeed(value: sample.speed)
        rootView.setSound(value: sample.volume)
    }
}

extension SoundControlViewController: SoundControlViewDelegate {

    func didUpdateSound(_ value: Double) {
        samplesConfigurator.set(sound: value)
        samplesPlayer.set(sound: value)
        playCurrentlySelectedSample()
    }

    func didUpdateSpeed(_ value: Double) {
        print(value)
        samplesConfigurator.set(speed: value)
        samplesPlayer.set(speed: value)
        playCurrentlySelectedSample()
    }

    func didFinishSlider(_ slider: UIView) {
        samplesPlayer.stopPlayer()
        guard let configuredSample = samplesConfigurator.currentlySelectedSample else { return }
        delegate?.didGenerateSample(configuredSample)
    }
}

extension SoundControlViewController: SoundPickerViewControllerDelegate {
    func didSelect(sample: SoundSample) {
        let configurableSample = samplesConfigurator.createSample(sample)
        delegate?.didGenerateSample(configurableSample)
    }
}
