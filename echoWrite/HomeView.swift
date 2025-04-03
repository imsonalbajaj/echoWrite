//
//  HomeView.swift
//  echowrite
//
//  Created by Sonal on 03/04/25.
//

import SwiftUI
import Lottie

struct HomeView: View {
    @State private var path: [NavScreen] = []
    @State private var startHear = false
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                List {
                    Text("1")
                    Text("1")
                    Text("1")
                    Text("1")
                    Text("1")
                    
                }
                .listStyle(.plain)
                
                Spacer()
                
                
                    
                Button {
                    startHear.toggle()
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
