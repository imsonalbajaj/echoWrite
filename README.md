# 🎙️ EchoWrite

A SwiftUI-based iOS app that listens to your voice, transcribes it using Apple’s Speech Recognition API, and generates intelligent summaries using the Natural Language framework.

![EchoWrite Icon](https://github.com/imsonalbajaj/echowrite/blob/main/echowrite/Assets.xcassets/AppIcon.appiconset/180.png?raw=true)

---

## ✨ Features

- 🎤 **Real-time Speech Recognition**  
  Uses `SFSpeechRecognizer` to transcribe your voice in real-time.

- 🧠 **On-device Text Summarization**  
  Extracts summary and title using Apple’s `NaturalLanguage` framework (`NLTagger`, `NLTokenizer`).

- 📂 **Local Persistence with SwiftData**  
  Stores your summaries using `@Model`, `@Query`, and SwiftData’s `ModelContainer`.

- 💾 **Offline-Friendly**  
  All processing (speech + NLP) works locally on-device. No internet required.

- 💡 **Clean UI**  
  Uses SwiftUI + Lottie for smooth animation and a distraction-free writing experience.

---

## 🖼️ Screenshots

| Splash View | Live Listening | Saved Summaries |
|-------------|----------------|------------------|
| ![Splash](https://github.com/imsonalbajaj/echowrite/blob/main/echowrite/Images/splashImage.PNG?raw=true) | ![Live](https://github.com/imsonalbajaj/echowrite/blob/main/echowrite/Images/liveImage.png?raw=true) | ![Summary](https://github.com/imsonalbajaj/echowrite/blob/main/echowrite/Images/savedSummaryImage.PNG?raw=true) |

---

## 📦 Tech Stack

- `SwiftUI` for modern UI
- `Speech` & `AVFoundation` for voice transcription
- `NaturalLanguage` for intelligent summarization
- `SwiftData` for local data storage
- `Lottie` for microphone animation

---

## 🛠 Installation

1. Clone the repo:
   ```bash
   git clone git@github.com:imsonalbajaj/echowrite.git

2.	Open in Xcode:
    ```bash
    open echowrite.xcodeproj

3. Run on an iOS device or simulator

