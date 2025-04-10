//
//  SplashView.swift
//  echowrite
//
//  Created by Sonal on 03/04/25.
//

import SwiftUI

struct SplashView: View {
    @Binding var showHomeView: Bool
    @State private var showProgressView = false
    @State private var showPermissionDeniedAlert = false
    @State private var onAppearCalled = false
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome to EchoWrite")
                    .foregroundStyle(Color.primary)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                if showProgressView {
                    ProgressView()
                        .frame(height: 50.0)
                        .task { await requestPermissions() }
                } else {
                    Button {
                        showProgressView = true
                    } label: {
                        Text("Next")
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.white)
                            .frame(height: 48.0)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.blue.opacity(0.8))
                            )
                            .shadow(radius: 1.0)
                            .padding(.horizontal, 32)
                            .frame(height: 50.0)
                    }
                }
            }
        }
        .onAppear {
            if !onAppearCalled {
                showProgressView = true
                onAppearCalled = true
            }
        }
        .alert("Permissions Needed", isPresented: $showPermissionDeniedAlert) {
            Button("Open Settings") {
                showProgressView = false
                openAppSettings()
            }
            Button("Cancel", role: .cancel) {
                showProgressView = false
            }
        } message: {
            Text("Please allow Speech Recognition and Microphone access in Settings to continue.")
        }
    }
    
    private func requestPermissions() async {
        let (speechGranted, micGranted) = await SoundManager.shared.requestSpeechRecognitionPermission()
        if speechGranted && micGranted {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run {
                showHomeView = true
            }
        } else {
            await MainActor.run {
                showPermissionDeniedAlert = true
            }
        }
    }
    
    private func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}
