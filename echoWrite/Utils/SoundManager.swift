//
//  SoundManager.swift
//  echowrite
//
//  Created by Sonal on 03/04/25.
//

import Foundation
import Speech
import AVFoundation

actor SoundManager {
    static let shared = SoundManager()
    
    func requestSpeechRecognitionPermission() async -> (Bool, Bool) {
        async let speechGranted = isSpeechRecognitionAuthorized()
        async let micGranted = isMicrophoneAccessGranted()
        return await (speechGranted, micGranted)
    }
    
    private func isSpeechRecognitionAuthorized() async -> Bool {
        await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status == .authorized)
            }
        }
    }
    
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
