//
//  SoundControlView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class SoundControlView: UIView {

    weak var delegate: SoundControlViewDelegate?
    
    private let headerContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()

    private let speedControlSlider: SpeedControlView = {
        let view = SpeedControlView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let soundSlider: VerticalSoundSlider = {
        let slider = VerticalSoundSlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    lazy var contentViewGradinet: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            UIColor.black.cgColor,
            Colors.blueGradient.cgColor
        ]
        gradient.locations = [0, 0.7]
        return gradient
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(headerContentView)
        addSubview(contentView)
        addSubview(speedControlSlider)
        addSubview(soundSlider)
        soundSlider.delegate = self
        speedControlSlider.delegate = self
        NSLayoutConstraint.activate([
            headerContentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            headerContentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerContentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerContentView.heightAnchor.constraint(equalToConstant: 90 + safeAreaInsets.top),
            contentView.topAnchor.constraint(equalTo: headerContentView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            speedControlSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            speedControlSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            speedControlSlider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            speedControlSlider.heightAnchor.constraint(equalToConstant: 14),
            soundSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            soundSlider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            soundSlider.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -26),
            soundSlider.widthAnchor.constraint(equalToConstant: 20)
        ])
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }

    func applyGradient() {
        contentViewGradinet.frame = contentView.bounds
        print(contentView.frame)
        contentView.layer.insertSublayer(contentViewGradinet, at: 0)
    }
    
    @objc private func tap() {
        print("TAP")
        print(speedControlSlider.frame)
        print(frame, bounds)
    }

    func updateSliderPositions() {
        bringSubviewToFront(speedControlSlider)
        bringSubviewToFront(soundSlider)
    }
}

extension SoundControlView: SliderDelegate {
    func didFinish(slider: UIView, with value: Double) {
        if slider == soundSlider {
            delegate?.didUpdateSound(value)
        } else {
            delegate?.didUpdateSpeed(value)
        }
    }
}
