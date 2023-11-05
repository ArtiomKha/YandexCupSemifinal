//
//  SoundwaveView.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/5/23.
//

import UIKit

class SoundwaveView: UIView {

    private let lineGap: CGFloat = 2
    private let lineWidth: CGFloat = 2

    var shapeLayer: CAShapeLayer!
    
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    private var frames: [CGFloat] = []

    private var waveCenter: CGFloat {
        bounds.height / 2
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
        shapeLayer = self.layer as? CAShapeLayer
        backgroundColor = .clear
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Colors.acidGreen.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.lineWidth = lineWidth
        shapeLayer.masksToBounds = true
    }

    func updateWave() {
        let pth = UIBezierPath()
        var x: CGFloat = 0
        for frame in frames {
            pth.move(to: CGPoint(x: x, y: max(0, waveCenter - frame / 2)))
            pth.addLine(to: CGPoint(x: x, y: min(bounds.height, waveCenter + frame / 2)))
            x += lineGap + lineWidth
        }
        shapeLayer.path = pth.cgPath
    }

    func addNewFrame(_ frame: CGFloat) {
        frames.append(frame)
        if frames.count > maxAmountOfFrames() {
            frames.removeFirst(frames.count - maxAmountOfFrames())
        }
        updateWave()
    }

    func clear() {
        frames = []
        updateWave()
    }

    func maxAmountOfFrames() -> Int {
        Int(bounds.width / (lineGap + lineWidth))
    }
}
