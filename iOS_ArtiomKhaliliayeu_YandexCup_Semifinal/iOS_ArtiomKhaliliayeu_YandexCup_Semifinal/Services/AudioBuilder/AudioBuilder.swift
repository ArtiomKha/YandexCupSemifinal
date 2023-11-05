//
//  AudioBuilder.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/4/23.
//

import AVFoundation

class AudioBuilder {
    
    weak var delegate: AudioBuilderDelegate?
    let engine: AVAudioEngine = AVAudioEngine()
    var audioFiles: [AVAudioFile] = []
    var audioNodes: [AVAudioPlayerNode] = []
    var mixer: AVAudioMixerNode// = AVAudioMixerNode()
    private var cachedAudioFiles: [String : AVAudioFile] = [:]
    private (set) var isPlaying = false
    private (set) var isRecording = false
    private (set) var selectedFileType: FileType = .m4a

    private var lastSoundwaveUpdate = Date.distantPast


    //MARK: - Recoding
    private var filePath: URL?
    
    init() {
        mixer = engine.mainMixerNode
//        engine.attach(mixer)
//        engine.connect(mixer, to: engine.outputNode, format: nil)
    }

    func buildAudioAndPlay(from samples: [ConfigurableSample]) {
        let samples = samples.filter { $0.isOn }
        guard !samples.isEmpty else { return }
        installTap()
        try! engine.start()
        for sample in samples {
            let node = AVAudioPlayerNode()
            node.rate = Float(sample.speed)
            node.volume = Float(sample.volume)
            engine.attach(node)
            engine.connect(node, to: mixer, format: nil)
            switch sample.filename {
            case .audioRecording(let url):
                guard let audioFile = try? AVAudioFile(forReading: url) else { continue }
                node.scheduleFile(audioFile, at: nil)
                node.play()
            default:
                guard let url = Bundle.main.url(forResource: sample.filename.name, withExtension: sample.filename.fileExtension), let audioFile = try? AVAudioFile(forReading: url) else { continue }
                guard let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFile.processingFormat, frameCapacity: AVAudioFrameCount(audioFile.length)) else { continue }
                try? audioFile.read(into: audioFileBuffer)
                node.scheduleBuffer(audioFileBuffer, at: nil, options: .loops, completionHandler: nil)
                node.play()
            }
            audioNodes.append(node)
        }
        if !isRecording {
            isPlaying = true
        }
    }

    func pause() {
        mixer.removeTap(onBus: 0)
        engine.pause()
        isPlaying = false
        for node in audioNodes {
            engine.detach(node)
        }
    }

    func setFileType(_ type: FileType) {
        selectedFileType = type
    }

    func buildAudioAndRecord(from samples: [ConfigurableSample]) {
        isRecording = true
        buildAudioAndPlay(from: samples)
    }

    private func installTap() {
        let tapNode = mixer
        let format = tapNode.outputFormat(forBus: 0)
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        filePath = documentURL.appendingPathComponent("recording.\(selectedFileType.humanReadable)")
        guard let file = try? AVAudioFile(forWriting: filePath!, settings: format.settings) else { return }
        tapNode.installTap(onBus: 0, bufferSize: 4096, format: format, block: { [weak self] (buffer, time) in
            if self?.isRecording ?? false {
                try? file.write(from: buffer)
            }
            self?.processBuffer(buffer)
        })
    }

    private func processBuffer(_ buffer: AVAudioPCMBuffer) {
        guard let value = SoundWaveProcessor().process(buffer: buffer), lastSoundwaveUpdate.distance(to: Date()) > 0.2 else { return }
        lastSoundwaveUpdate = Date()
        delegate?.didReceiveBuffer(size: value)
    }

    func stopRecording() -> URL? {
        isRecording = false
        pause()
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
