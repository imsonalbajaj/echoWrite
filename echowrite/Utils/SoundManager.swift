//
//  SoundManager.swift
//  echowrite
//
//  Created by Sonal on 03/04/25.
//

import Foundation
import Speech
import AVFoundation

/* ENSURES ALL ACCESS IS SERIALIZED AND THREAD-SAFE */
actor SoundManager {
    static let shared = SoundManager()
    
    /* REQUESTS BOTH SPEECH RECOGNITION AND MICROPHONE PERMISSIONS CONCURRENTLY */
    func requestSpeechRecognitionPermission() async -> (Bool, Bool) {
        async let speechGranted = isSpeechRecognitionAuthorized()
        async let micGranted = isMicrophoneAccessGranted()
        
        return await (speechGranted, micGranted)
    }
    
    /* SPEECH RECOGNITION PERMISSION REQUEST CHECK */
    private func isSpeechRecognitionAuthorized() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
    /* MICROPHONE ACCESS PERMISSION REQUEST CHECK */
    private func isMicrophoneAccessGranted() async -> Bool {
        await withCheckedContinuation { continuation in
            if #available(iOS 17.0, *) {
                AVAudioApplication.requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            } else {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    continuation.resume(returning: granted)
                }
            }
        }
    }
}
