//
//  SamplesListView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/2/23.
//

import UIKit

class SamplesListView: UIView {

    private let collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 7
        layout.scrollDirection = .vertical
        return layout
    }()

    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(collectionView)
        backgroundColor = .clear
        collectionView.backgroundColor = .clear
        collectionView.register(SampleCellView.self, forCellWithReuseIdentifier: SampleCellView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
