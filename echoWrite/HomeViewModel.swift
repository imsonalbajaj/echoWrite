//
//  HomeViewModel.swift
//  echoWrite
//
//  Created by Sonal on 04/04/25.
//

import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var transcribedText: String = ""
    private let speechRecognizer = SpeechRecognizer()

    func startListening() {
        Task {
            transcribedText = ""
            let stream = await speechRecognizer.transcriptionStream()

            for await text in stream {
                self.transcribedText = text
                print(text)
            }
        }
    }

    func stopListening() {
        Task {
            await speechRecognizer.stopListening()
            transcribedText = ""
        }
    }
}
