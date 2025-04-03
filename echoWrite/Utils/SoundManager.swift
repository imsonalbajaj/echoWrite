//
//  SoundManager.swift
//  echowrite
//
//  Created by Sonal on 03/04/25.
//

import Foundation
import Speech
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private init() {}
    
    func requestSpeechRecognitionPermission(completion: @escaping (Bool, Bool) -> Void) {
        isSpeechRecognitionAuthorized { isSpeechAuthorized in
            self.isMicrophoneAccessGranted { isMicAuthorized in
                completion(isSpeechAuthorized, isMicAuthorized)
            }
        }
    }
    
    func isSpeechRecognitionAuthorized(completion: @escaping (Bool) -> Void) {
        SFSpeechRecognizer.requestAuthorization { status in
            DispatchQueue.main.async {
                completion(status == .authorized)
            }
        }
    }
    
    func isMicrophoneAccessGranted(completion: @escaping (Bool) -> Void) {
        if #available(iOS 17.0, *) {
            AVAudioApplication.requestRecordPermission(completionHandler: { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            })
        } else {
            AVAudioSession.sharedInstance().requestRecordPermission { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        }
    }
}
