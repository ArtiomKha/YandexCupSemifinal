//
//  ViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class SoundMakerContainerController: UIViewController {

    private let samplesConfigurator: SamplesConfigurator = SamplesConfigurator()

    lazy var soundControlController = SoundControlViewController(samplesConfigurator: samplesConfigurator)
    let audioPlayerController = AudioPlayerViewController()
    let samplesListController = SamplesListViewController()
    let audioBuilder = AudioBuilder()
    let audioRecorder = AudioRecorder()
    private var samplesListHeightConstraint: NSLayoutConstraint?

    var samples: [ConfigurableSample] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildren()
    }

    private func setupChildren() {
        
        addChild(soundControlController)
        view.addSubview(soundControlController.view)
        soundControlController.view.translatesAutoresizingMaskIntoConstraints = false
        soundControlController.didMove(toParent: self)
        soundControlController.delegate = self
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
        if samplesListController.parent == nil && samples.count > 0 {
            addSamplesListController()
        } else {
            dismissSamplesList()
        }
        audioPlayerController.updateLayerButtonState(isExpanded: samplesListController.parent != nil)
        soundControlController.prepareForSamplesList(isPresented: samplesListController.parent != nil)
    }

    func dismissSamplesList() {
        samplesListController.willMove(toParent: nil)
        samplesListController.view.removeFromSuperview()
        samplesListController.removeFromParent()
    }

    private func addSamplesListController() {
        samplesListController.delegate = self
        addChild(samplesListController)
        view.addSubview(samplesListController.view)
        samplesListController.view.translatesAutoresizingMaskIntoConstraints = false
        samplesListController.didMove(toParent: self)
        
        NSLayoutConstraint.activate([
            samplesListController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            samplesListController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            samplesListController.view.bottomAnchor.constraint(equalTo: audioPlayerController.view.topAnchor, constant: 17)
        ])
        if samplesListHeightConstraint == nil {
            samplesListHeightConstraint = samplesListController.view.heightAnchor.constraint(equalToConstant: calculateSamplesListHeight())
            samplesListHeightConstraint?.isActive = true
        } else {
            samplesListHeightConstraint?.constant = calculateSamplesListHeight()
        }
        samplesListController.rootView.collectionView.reloadData()
    }

    private func calculateSamplesListHeight() -> CGFloat {
        min(samplesListController.contentHeight(), soundControlController.contentViewHeight)
    }

    func updateSamplesListDataSource() {
        let selectedSampleId = samplesConfigurator.currentlySelectedSample?.id
        let samplesListDataSource: [SampleViewCellModel] = samples.map { .init($0, isSelected: $0.id == selectedSampleId )}
        samplesListController.updateDataSource(samplesListDataSource)
    }
}

extension SoundMakerContainerController: SoundControlViewControllerDelegate {
    func didGenerateSample(_ sample: ConfigurableSample) {
        if let index = samples.firstIndex(where: { $0.id == sample.id }) {
            samples[index] = sample
        } else {
            samples.append(sample)
        }
        updateSamplesListDataSource()
    }
}

extension SoundMakerContainerController: SamplesListViewControllerDelegate {
    func didToggleSound(for sampleId: Int, value: Bool) {
        guard let sampleIndex = samples.firstIndex(where: { $0.id == sampleId }) else { return }
        samples[sampleIndex].isOn = value
    }

    func didRemoveSample(with id: Int) {
        samples.removeAll(where: { $0.id == id})
        if samples.isEmpty {
            presentSamplesListController()
        } else {
            samplesListHeightConstraint?.constant = calculateSamplesListHeight()
            samplesListController.view.layoutSubviews()
        }
    }

    func didSelectSample(wirh id: Int?) {
        let sample = samples.first(where: { $0.id == id })
        samplesConfigurator.setSample(sample)
    }
}
