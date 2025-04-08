//
//  HomeView.swift
//  echowrite
//
//  Created by Sonal on 03/04/25.
//

import SwiftUI
import Lottie
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [SummaryItem]
    
    @ObservedObject var viewModel = HomeViewModel()
    @State private var startHear = false
    let navHeading = "Your Summaries"
    
    var body: some View {
        NavigationStack() {
            VStack {
                ZStack(alignment: .top) {
                    VStack {
                        List {
                            ForEach(items) { item in
                                NavigationLink {
                                    SummaryView(summaryItem: item)
                                } label: {
                                    Text(item.heading)
                                        .foregroundStyle(Color.primary)
                                        .lineLimit(2)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                            }
                        }
                        
                        Spacer()
                    }
                    
                    if startHear {
                        Color(.systemBackground)
                        
                        VStack {
                            Text(viewModel.transcribedText)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundStyle(Color.primary)
                                .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.secondarySystemBackground))
                        }
                        .padding()
                        .shadow(color: Color(.systemGroupedBackground), radius: 0.1)
                    }
                }
                
                Spacer()
                
                Button {
                    startHear.toggle()
                    
                    if startHear {
                        viewModel.startListening()
                    } else {
                        viewModel.saveSummary(using: modelContext)
                        viewModel.stopListening()
                    }
                } label: {
                    if startHear {
                        LottieView(animation: .named(MIC_ANIMATED))
                            .looping()
                    } else {
                        Image(systemName: MICROPHONE)
                            .foregroundStyle(Color.white)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                
                .frame(width: 64, height: 64)
                .padding(.bottom, BOTTOM_INSET)
                .frame(maxWidth: .infinity, alignment: .center)
                .background(
                    LinearGradient(colors: [.teal, .cyan, .green], startPoint: .topLeading, endPoint: .bottomTrailing)
                )
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle(navHeading)
        }
    }
}
