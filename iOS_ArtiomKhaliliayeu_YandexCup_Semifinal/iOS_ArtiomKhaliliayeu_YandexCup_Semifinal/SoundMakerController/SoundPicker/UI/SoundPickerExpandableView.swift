//
//  SoundPickerExpandableView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/31/23.
//

import UIKit

protocol SoundPickerExpandableViewDelegate: AnyObject {
    func didSelectSample(_ sample: SoundSample)
}

class SoundPickerExpandableView: UIView {

    weak var delegate: SoundPickerExpandableViewDelegate?
    var samples: [SoundSample] = []

    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()

    private var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.alpha = 0
        view.backgroundColor = Colors.acidGreen
        return view
    }()

    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 30
        view.alpha = 0
        view.backgroundColor = Colors.acidGreen
        return view
    }()

    private var optionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.alpha = 0
        return stackView
    }()

    private var optionLabels: [SoundPickerLabelCell] = []
    private var contentViewHeightConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        addSubview(contentView)
        addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        contentView.addSubview(optionsStackView)
        
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 60)
        contentViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: 60),
            imageContainerView.topAnchor.constraint(equalTo: topAnchor),
            imageContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageContainerView.heightAnchor.constraint(equalToConstant: 60),
            optionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            optionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            optionsStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    func set(_ samples: [SoundSample]) {
        if samples.isEmpty {
            return //TODO: - Animate collapse
        }
        let type = samples[0].soundType
        self.samples = samples
        //MARK: - Image setup
        imageView.image = type.icon
        NSLayoutConstraint.deactivate(imageView.constraints)
        var imageConstraints = [
            imageView.widthAnchor.constraint(equalToConstant: type.iconSize.width),
            imageView.heightAnchor.constraint(equalToConstant: type.iconSize.height),
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor)
        ]
        if type.isImageCentered {
            imageConstraints.append(imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor))
        } else {
            imageConstraints.append(imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 5))
        }
        NSLayoutConstraint.activate(imageConstraints)
        for sample in samples {
            let label = SoundPickerLabelCell()
            label.tag = sample.id
            optionLabels.append(label)
            label.text = sample.humanReadable
            optionsStackView.addArrangedSubview(label)
        }
        
        animateAppear()
    }

    func animateAppear() {
        contentViewHeightConstraint?.constant = getContentViewMaxHeight(for: samples.count)
        contentView.layoutIfNeeded()
        UIView.animateKeyframes(withDuration: 0.75, delay: 0) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.24) {
                self.imageContainerView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.contentView.alpha = 1
            }
            UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.24) {
                self.optionsStackView.alpha = 1
            }
        }
        
        if let firstLabel = optionLabels.first {
            firstLabel.applyGradient()
            guard let sample = samples.first(where: { $0.id == firstLabel.tag }) else { return }
            delegate?.didSelectSample(sample)
        }
    }

    func collapse() {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.24) {
                self.contentView.alpha = 0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.imageContainerView.alpha = 0
            }
        }) { _ in
            self.isHidden = true
        }
        optionsStackView.alpha = 0
        optionsStackView.removeAllArrangedSubviews()
        optionLabels = []
    }

    private func getStackViewHeight(for samplesCount: Int) -> CGFloat {
        CGFloat(samplesCount * 30 + (samplesCount - 1) * 2)
    }

    private func getContentViewMaxHeight(for samplesCount: Int) -> CGFloat {
        getStackViewHeight(for: samplesCount) + 90
    }

    func receiveTouch(at point: CGPoint) {
        let translatedPoint = convert(point, to: optionsStackView)
        if translatedPoint.y < 0 {
            if optionLabels.first?.isGradientApplied ?? false { return }
            if let firstLabel = optionLabels.first {
                firstLabel.applyGradient()
                guard let sample = samples.first(where: { $0.id == firstLabel.tag }) else { return }
                delegate?.didSelectSample(sample)
            }
            for optionLabel in optionLabels[1...] {
                if !optionLabel.isGradientApplied { continue }
                optionLabel.removeGradient()
            }
            return
        } else if translatedPoint.y > optionsStackView.frame.maxX {
            if optionLabels.last?.isGradientApplied ?? false { return }
            if let lastLabel = optionLabels.last {
                lastLabel.applyGradient()
                guard let sample = samples.first(where: { $0.id == lastLabel.tag }) else { return }
                delegate?.didSelectSample(sample)
            }
            for optionLabel in optionLabels[0..<(optionLabels.count - 1)] {
                if !optionLabel.isGradientApplied { continue }
                optionLabel.removeGradient()
            }
            return
        }
        for optionLabel in optionLabels {
            if optionLabel.frame.contains(translatedPoint) {
                if optionLabel.isGradientApplied { continue }
                optionLabel.applyGradient()
                if let sample = samples.first(where: { $0.id == optionLabel.tag }) {
                    delegate?.didSelectSample(sample)
                }
            } else {
                if !optionLabel.isGradientApplied { continue }
                optionLabel.removeGradient()
            }
        }
    }
}

class SoundPickerLabelCell: UIView {

    lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.type = .axial
        gradient.colors = [
            Colors.acidGreen.cgColor,
            UIColor.white.cgColor,
            Colors.acidGreen.cgColor
        ]
        gradient.locations = [0, 0.5, 1]
        return gradient
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var text: String = "" {
        didSet {
            label.text = text
        }
    }

    var isGradientApplied: Bool {
        gradient.superlayer != nil
    }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func applyGradient() {
        gradient.frame = self.bounds
        layer.insertSublayer(gradient, at: 0)
        
    }

    func removeGradient() {
        if gradient.superlayer != nil {
            gradient.removeFromSuperlayer()
        }
    }
}
