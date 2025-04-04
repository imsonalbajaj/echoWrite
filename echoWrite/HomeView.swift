//
//  HomeView.swift
//  echowrite
//
//  Created by Sonal on 03/04/25.
//

import SwiftUI
import Lottie

struct HomeView: View {
    @ObservedObject var viewModel = HomeViewModel()
    @State private var path: [NavScreen] = []
    @State private var startHear = false
    
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()
                
                Text(viewModel.transcribedText)
                    .foregroundStyle(Color.black)
                    
                Button {
                    startHear.toggle()
                    
                    if startHear {
                        viewModel.startListening()
                    } else {
                        viewModel.stopListening()
                    }
                } label: {
                    if startHear {
                        LottieView(animation: .named("micAnimated"))
                            .looping()
                    } else {
                        Image(systemName: MICROPHONE)
                            .foregroundStyle(Color.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .frame(width: 64, height: 64)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    Color.teal
                        .frame(height: 60)
                )
            }
            .navigationTitle("Your Summaries")
        }
        
    }
}

