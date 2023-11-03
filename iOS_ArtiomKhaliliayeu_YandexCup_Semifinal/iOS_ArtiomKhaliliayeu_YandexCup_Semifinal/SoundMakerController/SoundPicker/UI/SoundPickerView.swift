//
//  SoundPickerView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 10/30/23.
//

import UIKit

class SoundPickerView: UIView {

    weak var delegate: SoundPickerViewDelegate?

    private let soundsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.backgroundColor = .black
        return stackView
    }()

    var contentBottomAnchor: NSLayoutYAxisAnchor {
        soundsStackView.bottomAnchor
    }

    private var pickerViews: [SoundPickerCellView] = []
    private var menuViewTopConstraint: NSLayoutConstraint?
    private var menuViewLeadingContraint: NSLayoutConstraint?

    private let extendedView: SoundPickerExpandableView = {
        let view = SoundPickerExpandableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        backgroundColor = .clear
        addSubview(soundsStackView)
        NSLayoutConstraint.activate([
            soundsStackView.topAnchor.constraint(equalTo: topAnchor),
            soundsStackView.heightAnchor.constraint(equalToConstant: 90),
            soundsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            soundsStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        addSubview(extendedView)
        extendedView.delegate = self
    }

    func set(soundTypes: [SoundTypes]) {
        pickerViews = []
        soundsStackView.subviews.forEach {
            soundsStackView.removeArrangedSubview($0)
        }
        for type in soundTypes {
            let cellView = SoundPickerCellView()
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.set(type: type)
            cellView.tag = type.id
            cellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellPickerTapHandler(_:))))
            cellView.addGestureRecognizer(getLongPressGestureHandler())
            soundsStackView.addArrangedSubview(cellView)
            pickerViews.append(cellView)
            NSLayoutConstraint.activate([
                cellView.heightAnchor.constraint(equalToConstant: 60),
                cellView.widthAnchor.constraint(equalToConstant: 60)
            ])
        }
    }

    private func getLongPressGestureHandler() -> UILongPressGestureRecognizer {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellPickerLongTapHandler(_ :)))
        recognizer.minimumPressDuration = 0.5
        return recognizer
    }

    @objc func cellPickerTapHandler(_ sender: UITapGestureRecognizer) {
        guard let senderView = sender.view as? SoundPickerCellView else { return }
        delegate?.didTapOnSound(with: senderView.tag)
    }

    @objc private func cellPickerLongTapHandler(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            guard let senderView = sender.view as? SoundPickerCellView else { return }
            delegate?.didLongTapOnSound(with: senderView.tag)
        case .changed:
            extendedView.receiveTouch(at: sender.location(in: extendedView))
        case .ended, .cancelled:
            collapseMenu()
            delegate?.didFinishSamplesPreview()
        case .failed:
            collapseMenu()
        default:
            break
        }
        
    }

    func displayExpandedView(for samples: [SoundSample]) {
        guard !samples.isEmpty else { return }
        let tag = samples[0].soundType.id
        guard let pickerView = pickerViews.first(where: { $0.tag == tag }) else { return }
        extendedView.isHidden = false
        
        menuViewTopConstraint?.isActive = false
        menuViewLeadingContraint?.isActive = false
        
        menuViewTopConstraint = extendedView.topAnchor.constraint(equalTo: pickerView.topAnchor)
        menuViewLeadingContraint = extendedView.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor)
        
        menuViewTopConstraint?.isActive = true
        menuViewLeadingContraint?.isActive = true
        
        extendedView.set(samples)
        disablePickers(except: tag)
    }

    private func disablePickers(except selectedPickerId: Int) {
        for pickerView in pickerViews {
            if pickerView.tag == selectedPickerId { continue }
            pickerView.isEnabled = false
        }
    }

    private func enablePickers() {
        for pickerView in pickerViews {
            pickerView.isEnabled = true
        }
    }

    func collapseMenu() {
        extendedView.collapse()
        enablePickers()
    }
}

extension SoundPickerView: SoundPickerExpandableViewDelegate {
    func didSelectSample(_ sample: SoundSample) {
        delegate?.didSelectedSample(for: sample.soundType.id, sample.id)
    }
}
