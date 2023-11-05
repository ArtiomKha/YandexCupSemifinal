//
//  SoundWaveProcessor.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/5/23.
//

import AVFoundation
import Accelerate

struct SoundWaveProcessor {

    private let bottomBound: Float = 3
    private let upperBound: Float = 32

    private func rms(data: UnsafeMutablePointer<Float>, frameLength: UInt) -> Float {
        var value: Float = 0
        vDSP_measqv(data, 1, &value, frameLength)
        value *= 1000
        return value
    }

    private func normalize(soundLevel: Float) -> CGFloat {
        var level = soundLevel * 1.3
        if level < bottomBound {
            level = bottomBound
        }
        if level > upperBound {
            level = upperBound
        }
        return CGFloat(level)
    }

    func process(buffer: AVAudioPCMBuffer) -> CGFloat? {
        guard let data = buffer.floatChannelData?[0] else { return nil }
        let level = 10 * log10f(rms(data: data, frameLength: UInt(buffer.frameLength)))
        return normalize(soundLevel: level)
    }
}
