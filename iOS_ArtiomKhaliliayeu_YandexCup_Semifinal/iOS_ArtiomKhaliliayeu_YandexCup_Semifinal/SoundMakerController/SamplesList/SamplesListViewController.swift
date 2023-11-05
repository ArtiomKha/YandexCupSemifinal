//
//  SamplesListViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

class SamplesListViewController: UIViewController {

    weak var delegate: SamplesListViewControllerDelegate?
    var dataSource: [SampleViewCellModel] = []
    private let samplesPlayer = SamplesPlayer()

    var rootView: SamplesListView {
        view as! SamplesListView
    }

    override func loadView() {
        view = SamplesListView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        samplesPlayer.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        samplesPlayer.stopPlayer()
    }

    func setupCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.reloadData()
    }

    func contentHeight() -> CGFloat {
        CGFloat(dataSource.count) * 39 + CGFloat(dataSource.count - 1) * 7
    }

    func updateDataSource(_ samples: [SampleViewCellModel]) {
        dataSource = samples
    }

    //MARK: - Cell actions
    private func deleteSample(at index: Int) {
        if dataSource[index].isPlaying {
            samplesPlayer.stopPlayer(notify: false)
        }
        if dataSource[index].isSelected {
            delegate?.didSelectSample(wirh: nil)
        }
        let sampleId = dataSource[index].id
        dataSource.remove(at: index)
        rootView.collectionView.reloadData()
        delegate?.didRemoveSample(with: sampleId)
    }

    private func playSample(at index: Int) {
        if !dataSource[index].isPlaying, let currentlyPlayingIndex = dataSource.firstIndex(where: { $0.isPlaying }) {
            dataSource[currentlyPlayingIndex].isPlaying = false
            rootView.collectionView.reloadItems(at: [.init(row: currentlyPlayingIndex, section: 0)])
        }
        dataSource[index].isPlaying.toggle()
        if dataSource[index].isPlaying {
            samplesPlayer.playFullFromSound(filename: dataSource[index].filename, with: dataSource[index].sound, and: dataSource[index].speed)
        } else {
            samplesPlayer.stopPlayer()
        }
        rootView.collectionView.reloadItems(at: [.init(row: index, section: 0)])
    }

    private func toggleSound(at index: Int) {
        dataSource[index].isSoundOn.toggle()
        rootView.collectionView.reloadItems(at: [.init(row: index, section: 0)])
        delegate?.didToggleSound(for: dataSource[index].id, value: dataSource[index].isSoundOn)
    }
}

// TODO: - Amination
// https://medium.com/@fabiogiolito/grid-animation-effects-in-swift-4d6ea4d6360d
extension SamplesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SampleCellView.identifier, for: indexPath) as? SampleCellView else { return UICollectionViewCell() }
        cell.set(dataSource[indexPath.row])
        cell.closeButtonAction = {
            self.deleteSample(at: indexPath.row)
        }
        cell.playButtonAction = {
            self.playSample(at: indexPath.row)
        }
        cell.soundButtonAction = {
            self.toggleSound(at: indexPath.row)
        }
        return cell
    }
}

extension SamplesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !dataSource[indexPath.row].filename.isAudioRecoridng else { return }
        var indiciesToReload = [indexPath]
        
        if !dataSource[indexPath.row].isSelected {
            if let selectedIndex = dataSource.firstIndex(where: { $0.isSelected }) {
                dataSource[selectedIndex].isSelected = false
                indiciesToReload.append(.init(row: selectedIndex, section: 0))
            }
            delegate?.didSelectSample(wirh: dataSource[indexPath.row].id)
        } else {
            delegate?.didSelectSample(wirh: nil)
        }
        dataSource[indexPath.row].isSelected.toggle()
        collectionView.reloadItems(at: indiciesToReload)
    }
}

extension SamplesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 39)
    }
}

extension SamplesListViewController: SamplesPlayerDelegate {
    func didFinishPlaying() {
        guard let currentlyPlayingIndex = dataSource.firstIndex(where: { $0.isPlaying }) else { return }
        dataSource[currentlyPlayingIndex].isPlaying = false
        rootView.collectionView.reloadItems(at: [.init(row: currentlyPlayingIndex, section: 0)])
    }
}
