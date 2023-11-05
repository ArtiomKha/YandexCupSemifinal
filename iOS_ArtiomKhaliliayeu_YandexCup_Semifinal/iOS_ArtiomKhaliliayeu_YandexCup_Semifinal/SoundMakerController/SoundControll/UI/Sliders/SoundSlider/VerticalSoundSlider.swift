//
//  VerticalSoundSlider.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/1/23.
//

import UIKit

class VerticalSoundSlider: UIView {

    weak var delegate: SliderDelegate?

    var currentValue: Double {
        get {
            var value: Double
            if thumbView.frame.maxY == bounds.height {
                value = 0
            } else if thumbView.frame.minY == 0 {
                value = 1
            } else {
                let thumProgress = 1 - (((thumbView.frame.minY + thumbView.frame.maxY) / 2) / bounds.height)
                value = Double(1 - ((thumbView.frame.maxY - thumbView.bounds.height * thumProgress) / bounds.height))
                if value < 0 {
                    value = 0
                } else if value > 1 {
                    value = 1
                }
            }
            return value
        }
        
        set {
            updateThumbPosition(for: newValue)
        }
    }

    public var contentOffset: CGFloat = 0 {
        didSet {
            layer.bounds.origin.x = contentOffset
        }
    }

    override var bounds: CGRect {
        didSet {
            updateRuler()
        }
    }

    private let lineWidth: CGFloat = 1
    private let numberOfLines = 26

    var shapeLayer: CAShapeLayer!
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    private let thumbView: SoundControlSliderThumb = {
        let view = SoundControlSliderThumb()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let thumbHitView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    private var thumbBottomConstraint: NSLayoutConstraint!
    private var panGesture: UIPanGestureRecognizer!
    private var yEndingPoint: CGFloat {
            return (self.bounds.height - thumbView.bounds.height)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() -> Void {
        shapeLayer = self.layer as? CAShapeLayer
        backgroundColor = .clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.masksToBounds = true
        addSubview(thumbView)
        addSubview(thumbHitView)
        NSLayoutConstraint.activate([
            thumbView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbView.widthAnchor.constraint(equalToConstant: 14),
            thumbView.heightAnchor.constraint(equalToConstant: thumbView.getLabelWidth() + 6),
            thumbHitView.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbHitView.heightAnchor.constraint(equalToConstant: 120),
            thumbHitView.widthAnchor.constraint(equalToConstant: 44),
            thumbHitView.centerYAnchor.constraint(equalTo: thumbView.centerYAnchor)
        ])
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 0
        thumbHitView.addGestureRecognizer(panGesture)
        thumbBottomConstraint = thumbView.bottomAnchor.constraint(equalTo: bottomAnchor)
        thumbBottomConstraint?.isActive = true
    }

    func updateRuler() -> Void {
        let pth = UIBezierPath()
        var numberOfLines = self.numberOfLines
        var y: CGFloat = 0
        var i = 0
        let lineGap = getLineGap()
        while numberOfLines > 0 {
            pth.move(to: CGPoint(x: 0, y: y))
            pth.addLine(to: CGPoint(x: i % 5 == 0 ? 13 : 7, y: y))
            y += lineGap + lineWidth
            i += 1
            numberOfLines -= 1
        }
        shapeLayer.path = pth.cgPath
    }

    func getLineGap() -> CGFloat {
        let height = bounds.height
        let heightWithoutLines = height - (CGFloat(numberOfLines) * lineWidth)
        return heightWithoutLines / CGFloat(numberOfLines - 1)
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        var translation = sender.translation(in: self)
        switch sender.state {
        case .began:
            break
        case .changed:
            var draggedDistance: CGFloat = thumbBottomConstraint.constant + translation.y
            if draggedDistance >= 0 {
                draggedDistance = 0
                translation.y += thumbBottomConstraint.constant
            } else if draggedDistance <= -1 * yEndingPoint {
                draggedDistance = -1 * yEndingPoint
                translation.y += thumbBottomConstraint.constant + yEndingPoint
            } else {
                translation.y = 0
            }
            updateThumbnailYPosition(draggedDistance)
            self.panGesture.setTranslation(translation, in: self)
            calculateCurrentValue()
        case .ended:
            delegate?.didFinish(slider: self)
        default:
            break
        }
    }

    private func updateThumbnailYPosition(_ y: CGFloat) {
        thumbBottomConstraint?.constant = y
        UIView.animate(withDuration: 0.1) {
            self.setNeedsLayout()
        }
    }

    private func calculateCurrentValue() {
        delegate?.valueChanged(slider: self, with: currentValue)
    }

    private func updateThumbPosition(for value: Double) {
        updateThumbnailYPosition(-1 * (bounds.height - thumbView.bounds.height) * value)
    }
}
