//
//  HomeViewModel.swift
//  echoWrite
//
//  Created by Sonal on 04/04/25.
//

import SwiftUI
import SwiftData

@MainActor
class HomeViewModel: ObservableObject {
    @Published var transcribedText: String = ""
    private let speechRecognizer = SpeechRecognizer()

    /* STARTS LISTENING TO MICROPHONE AND UPDATES transcribedText CONTINUOUSLY */
    func startListening() {
        Task {
            transcribedText = ""
            let stream = await speechRecognizer.transcriptionStream()

            for await text in stream {
                self.transcribedText = text
            }
        }
    }

    func stopListening() {
        Task {
            await speechRecognizer.stopListening()
            transcribedText = ""
        }
    }

    func saveSummary(using context: ModelContext) {
        guard !transcribedText.isEmpty else { return }
        let temp = TextSummarizer.summarize(text: transcribedText)
        print("transcription", transcribedText)
        print("heading", temp.heading)
        print("summary", temp.summary)

        withAnimation {
            let newItem = SummaryItem(timestamp: Date(), heading: "", summary: "", text: transcribedText)
            context.insert(newItem)
        }
    }
}
