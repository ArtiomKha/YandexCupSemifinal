//
//  FIleTypePickerView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/5/23.
//

import UIKit

protocol FileTypePickerDelegate: AnyObject {
    func didSelect(_ type: FileType)
}

class FIleTypePickerView: UIView {

    weak var delegate: FileTypePickerDelegate?

    private let stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 4
        stackView.isUserInteractionEnabled = true
        stackView.layer.masksToBounds = true
        return stackView
    }()

    private var labels: [UILabel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        for fileType in FileType.allCases {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = fileType.humanReadable
            label.font = .systemFont(ofSize: 14)
            label.tag = fileType.rawValue
            label.textColor = .white
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
            labels.append(label)
        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap(_:))))
    }

    @objc private func didTap(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: stackView)
        guard let senderView = findCorrectLabel(for: point), let fileType = FileType(rawValue: senderView.tag) else { return }
        for label in labels {
            if label != senderView {
                label.backgroundColor = .clear
                label.textColor = .white
            } else {
                label.backgroundColor = Colors.acidGreen
                label.textColor = .black
            }
        }
        delegate?.didSelect(fileType)
    }

    private func findCorrectLabel(for point: CGPoint) -> UILabel? {
        for label in labels {
            if label.frame.contains(point) {
                return label
            }
        }
        return nil
    }

    func set(_ type: FileType) {
        for label in labels {
            if label.tag != type.rawValue {
                label.backgroundColor = .clear
                label.textColor = .white
            } else {
                label.backgroundColor = Colors.acidGreen
                label.textColor = .black
            }
        }
    }
}
