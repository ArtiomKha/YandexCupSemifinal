//
//  AudioRecorder.swift
//  iOS_ArtiomKhaliliayeu_YandexCup_Semifinal
//
//  Created by Artsiom on 11/4/23.
//

import AVFoundation

class AudioRecorder {

    private var recordingSession: AVAudioSession
    private var soundRecorder: AVAudioRecorder?
    
    var isRecording: Bool = false
    private var currentRecordUrl: URL?
    
    init(recordingSession: AVAudioSession = AVAudioSession.sharedInstance(), soundRecorder: AVAudioRecorder? = nil) {
        self.recordingSession = recordingSession
        self.soundRecorder = soundRecorder
    }
    
    func checkAuthorisation(completion: @escaping (Bool) -> Void) {
        if recordingSession.recordPermission == .granted {
            completion(true)
        } else {
            recordingSession.requestRecordPermission(completion)
        }
    }

    func startRecording() {
        try? recordingSession.setCategory(.playAndRecord, mode: .default)
        try? recordingSession.setActive(true)
        currentRecordUrl = generateRecordURL()

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            soundRecorder = try AVAudioRecorder(url: currentRecordUrl!, settings: settings)
            soundRecorder?.record()
            isRecording = true
        } catch {
            print(error)
        }
    }

    func stopRecording() -> URL? {
        isRecording = false
        soundRecorder?.stop()
        soundRecorder = nil
        return currentRecordUrl
    }

    private func generateRecordURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let id = UUID().uuidString
        return documentsDirectory.appendingPathComponent("\(id).m4a")
    }
}
