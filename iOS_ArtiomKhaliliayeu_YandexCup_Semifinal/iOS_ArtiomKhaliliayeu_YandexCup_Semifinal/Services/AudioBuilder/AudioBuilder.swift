//
//  AudioBuilder.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/4/23.
//

import AVFoundation

class AudioBuilder {
    
    let engine: AVAudioEngine = AVAudioEngine()
    var audioFiles: [AVAudioFile] = []
    var audioNodes: [AVAudioPlayerNode] = []
    var mixer: AVAudioMixerNode = AVAudioMixerNode()
    private var cachedAudioFiles: [String : AVAudioFile] = [:]
    private (set) var isPlaying = false
    private (set) var isRecording = false


    //MARK: - Recoding
    private var filePath: URL?
    
    init() {
        engine.attach(mixer)
        engine.connect(mixer, to: engine.outputNode, format: nil)
    }

    func buildAudioAndPlay(from samples: [ConfigurableSample]) {
        audioFiles = samples.compactMap({ sample in
            guard let url = Bundle.main.url(forResource: sample.filename.name, withExtension: sample.filename.fileExtension), let audioFile = try? AVAudioFile(forReading: url) else { return nil }
            return audioFile
        })
        audioNodes = samples.map {
            let node = AVAudioPlayerNode()
            node.rate = Float($0.speed)
            node.volume = Float($0.volume)
            return node
        }

        try! engine.start()
        for i in 0...(audioFiles.count - 1) {
            guard let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFiles[i].processingFormat, frameCapacity: AVAudioFrameCount(audioFiles[i].length)) else { continue }
            try? audioFiles[i].read(into: audioFileBuffer)
            engine.attach(audioNodes[i])
            engine.connect(audioNodes[i], to: mixer, format: nil)
            audioNodes[i].scheduleBuffer(audioFileBuffer, at: nil, options: .loops, completionHandler: nil)
            audioNodes[i].play()
            print("Added \(i)")
        }
    
        print("Engine playing")
        if !isRecording {
            isPlaying = true
        }
    }

    func pause() {
        engine.pause()
        isPlaying = false
        for node in audioNodes {
            engine.detach(node)
        }
    }

    func buildAudioAndRecord(from samples: [ConfigurableSample]) {
        let tapNode = mixer
        let format = tapNode.outputFormat(forBus: 0)
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        filePath = documentURL.appendingPathComponent("recording.caf")
        guard let file = try? AVAudioFile(forWriting: filePath!, settings: format.settings) else { return }
        tapNode.installTap(onBus: 0, bufferSize: 4096, format: format, block: {
          (buffer, time) in
          try? file.write(from: buffer)
        })
        isRecording = true
        buildAudioAndPlay(from: samples)
    }

    func stopRecording() -> URL? {
        isRecording = false
        pause()
        self.mixer.removeTap(onBus: 0)
        return filePath
    }

    private func createNodeFor(sample: ConfigurableSample) async -> AVAudioPlayerNode? {
        guard let url = Bundle.main.url(forResource: sample.filename.name, withExtension: sample.filename.fileExtension) else { return nil }
        let node = AVAudioPlayerNode()
        guard let audioFile = try? AVAudioFile(forReading: url) else { return nil }
        await node.scheduleFile(audioFile, at: nil)
        node.rate = Float(sample.speed)
        node.volume = Float(sample.volume)
        return node
    }
}
