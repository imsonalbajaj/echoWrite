//
//  SpeechRecognizer.swift
//  echoWrite
//
//  Created by Sonal on 04/04/25.
//

import Speech
import AVFoundation

actor SpeechRecognizer {
    private let speechRecognizer = SFSpeechRecognizer()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()

    func transcriptionStream() -> AsyncStream<String> {
        AsyncStream { continuation in
            Task {
                await self.startListening { text in
                    continuation.yield(text)
                }
                /* continuation.finish() */
            }
        }
    }

    private func startListening(completion: @escaping (String) -> Void) async {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else { return }
        guard !audioEngine.isRunning else { return }

        do {
            let node = audioEngine.inputNode
            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            recognitionRequest = request

            recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
                if let result = result {
                    completion(result.bestTranscription.formattedString)
                }
                if error != nil {
                    Task { await self.stopListening() }
                }
            }

            let recordingFormat = node.outputFormat(forBus: 0)
            node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                Task { @MainActor in
                    await self.recognitionRequest?.append(buffer)
                }
            }

            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Speech recognition failed: \(error)")
            await stopListening()
        }
    }

    func stopListening() async {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}
