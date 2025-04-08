//
//  SpeechRecognizer.swift
//  echoWrite
//
//  Created by Sonal on 04/04/25.
//

import Speech
import AVFoundation

// The SpeechRecognizer actor is responsible for handling live speech-to-text transcription using Apple's Speech framework.
actor SpeechRecognizer {
    
    private let speechRecognizer = SFSpeechRecognizer() /* HANDLE SPEECH-TO-TEXT */
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest? /* REQUEST OBJECT FOR MANAGING AUDIO INPUT FOR RECOGNITION */
    private var recognitionTask: SFSpeechRecognitionTask? /* TASK THAT HANDLES THE ONGOING SPEECH RECOGNITION SESSION */
    private let audioEngine = AVAudioEngine() /* AUDIO ENGINE TO CAPTURE AUDIO INPUT FROM MICROPHONE */

    
    /* RETURNS AN ASYNCSTREAM OF TRANSCRIBED TEXT FROM MICROPHONE INPUT */
    func transcriptionStream() -> AsyncStream<String> {
        AsyncStream { continuation in
            Task {
                /* STARTS LISTENING AND YIELDS TRANSCRIBED TEXT AS IT COMES */
                await self.startListening { text in
                    continuation.yield(text)
                }
                /* continuation.finish() */ /* OPTIONALLY FINISH THE STREAM AFTER COMPLETION */
            }
        }
    }

    /* BEGINS AUDIO CAPTURE AND INITIALIZES SPEECH RECOGNITION */
    private func startListening(completion: @escaping (String) -> Void) async {
        /* ENSURE SPEECH RECOGNITION IS AUTHORIZED */
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else { return }
        
        /* RETURN IF AUDIO ENGINE IS ALREADY RUNNING TO AVOID DUPLICATE TASKS */
        guard !audioEngine.isRunning else { return }

        do {
            let node = audioEngine.inputNode
            let request = SFSpeechAudioBufferRecognitionRequest()
            request.shouldReportPartialResults = true
            recognitionRequest = request

            /* START RECOGNITION TASK AND HANDLE RESULTS OR ERRORS */
            recognitionTask = speechRecognizer?.recognitionTask(with: request) { result, error in
                if let result = result {
                    /* SEND THE LATEST TRANSCRIPTION TO THE COMPLETION HANDLER */
                    completion(result.bestTranscription.formattedString)
                }
                if error != nil {
                    /* STOP LISTENING IF AN ERROR OCCURS */
                    Task { await self.stopListening() }
                }
            }

            /* SETUP AUDIO ENGINE TO FEED MICROPHONE AUDIO INTO RECOGNITION REQUEST */
            let recordingFormat = node.outputFormat(forBus: 0)
            node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
                Task { @MainActor in
                    /* APPEND CAPTURED AUDIO TO THE RECOGNITION REQUEST */
                    await self.recognitionRequest?.append(buffer)
                }
            }

            /* CONFIGURE AUDIO SESSION FOR RECORDING */
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            /* PREPARE AND START AUDIO ENGINE */
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Speech recognition failed: \(error)")
            await stopListening()
        }
    }

    /* STOPS AUDIO CAPTURE AND CLEANS UP RESOURCES */
    func stopListening() async {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}
