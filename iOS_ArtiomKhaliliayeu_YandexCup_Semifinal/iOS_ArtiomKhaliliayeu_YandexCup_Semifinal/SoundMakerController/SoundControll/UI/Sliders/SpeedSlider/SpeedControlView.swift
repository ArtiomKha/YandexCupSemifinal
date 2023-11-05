//
//  RulerView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/1/23.
//

import UIKit

class SpeedControlView: UIView {

    weak var delegate: SliderDelegate?

    var minValue = 0.3
    var maxValue = 3.0

    var currentValue: Double {
        get {
            var value: Double = getCurrentValueUnformatted()
            value = (maxValue - minValue) * value + minValue
            return value
        }
        set {
            let receivedValue = newValue < minValue ? minValue : (newValue > maxValue ? maxValue : newValue)
            let value = (receivedValue - minValue) / (maxValue - minValue)
            updateThumbPosition(for: value)
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

    private let thumbView: SpeedControlSliderThumb = {
        let thumb = SpeedControlSliderThumb()
        thumb.translatesAutoresizingMaskIntoConstraints = false
        return thumb
    }()

    private let thumbHitView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    let minLineGap: CGFloat = 2
    private let lineWidth: CGFloat = 1
    private let amountOfRepetitionsForLineGap = 9

    var shapeLayer: CAShapeLayer!
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    private var thumbLeadingConstraint: NSLayoutConstraint?
    private var panGesture: UIPanGestureRecognizer!
    private var xEndingPoint: CGFloat {
            return (self.bounds.width - thumbView.bounds.width)
    }

    init() {
        super.init(frame: .zero)
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
        thumbLeadingConstraint = thumbView.leadingAnchor.constraint(equalTo: leadingAnchor)
        thumbLeadingConstraint?.isActive = true
        NSLayoutConstraint.activate([
            thumbView.bottomAnchor.constraint(equalTo: bottomAnchor),
            thumbView.heightAnchor.constraint(equalToConstant: 14),
            thumbView.widthAnchor.constraint(greaterThanOrEqualToConstant: 50),
            thumbHitView.bottomAnchor.constraint(equalTo: bottomAnchor),
            thumbHitView.centerXAnchor.constraint(equalTo: thumbView.centerXAnchor),
            thumbHitView.heightAnchor.constraint(equalToConstant: 44),
            thumbHitView.widthAnchor.constraint(equalToConstant: 120)
        ])
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 0
        thumbHitView.addGestureRecognizer(panGesture)
    }

    func updateRuler() -> Void {
        let pth = UIBezierPath()
        var x: CGFloat = 1
        var i = 0
        var lineGap = getMaxLineGap()
        while x <= bounds.width {
            pth.move(to: CGPoint(x: x, y: bounds.height - 14))
            pth.addLine(to: CGPoint(x: x, y: bounds.height))
            x += lineGap + lineWidth
            i += 1
            if i == amountOfRepetitionsForLineGap && lineGap > 2 {
                lineGap -= 1
                i = 0
            }
        }
        shapeLayer.path = pth.cgPath
    }

    func getMaxLineGap() -> CGFloat {
        var width = bounds.width
        var lineGap: CGFloat = minLineGap
        while width > 0 {
            width -= lineGap * CGFloat(amountOfRepetitionsForLineGap) + lineWidth * CGFloat(amountOfRepetitionsForLineGap + 1)
            lineGap += 1
        }
        return lineGap
    }

    @objc private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        var translation = sender.translation(in: self)
        switch sender.state {
        case .began:
            break
        case .changed:
            var draggedDistance: CGFloat = (thumbLeadingConstraint?.constant ?? 0) + translation.x
            if draggedDistance >= xEndingPoint {
                draggedDistance = xEndingPoint
                translation.x += (thumbLeadingConstraint?.constant ?? 0) - xEndingPoint
            } else if draggedDistance <= 0 {
                draggedDistance = 0
                translation.x += (thumbLeadingConstraint?.constant ?? 0)
            } else {
                translation.x = 0
            }
            updateThumbnailXPosition(draggedDistance)
            self.panGesture.setTranslation(translation, in: self)
            calculateCurrentValue()
        case .ended:
            delegate?.didFinish(slider: self)
        default:
            break
        }
    }

    private func updateThumbnailXPosition(_ x: CGFloat) {
        thumbLeadingConstraint?.constant = x
        UIView.animate(withDuration: 0.1) {
            self.setNeedsLayout()
        }
    }

    private func calculateCurrentValue() {
        delegate?.valueChanged(slider: self, with: currentValue)
    }

    private func getCurrentValueUnformatted() -> Double {
        let value: Double
        if thumbView.frame.minX == 0 {
            value = 0
        } else if thumbView.frame.maxX == bounds.width {
            value = 1
        } else {
            let thumProgress = ((thumbView.frame.maxX + thumbView.frame.minX) / 2) / bounds.width
            value = Double((thumbView.frame.minX + thumProgress * thumbView.bounds.width) / bounds.width)
        }
        return value
    }

    private func updateThumbPosition(for value: Double) {
        let thumbMinX = xEndingPoint * value
        updateThumbnailXPosition(thumbMinX)
    }
}
