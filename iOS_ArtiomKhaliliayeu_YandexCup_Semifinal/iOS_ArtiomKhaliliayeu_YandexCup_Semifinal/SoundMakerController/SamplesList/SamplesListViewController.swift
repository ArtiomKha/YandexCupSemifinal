//
//  SamplesListViewController.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

class SamplesListViewController: UIViewController {

    var dataSource: [SampleViewCellModel] = [.init(id: 1, sampleName: "Sample 1"), .init(id: 1, sampleName: "Sample 1"), .init(id: 1, sampleName: "Sample 1"), .init(id: 1, sampleName: "Sample 1"), .init(id: 1, sampleName: "Sample 1")]

    var rootView: SamplesListView {
        view as! SamplesListView
    }

    override func loadView() {
        view = SamplesListView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
        rootView.collectionView.reloadData()
    }

    func contentHeight() -> CGFloat {
        CGFloat(dataSource.count) * 39 + CGFloat(dataSource.count - 1) * 7
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
        return cell
    }
}

extension SamplesListViewController: UICollectionViewDelegate {
    
}

extension SamplesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(view.bounds.width)
        return CGSize(width: view.bounds.width, height: 39)
    }
}
