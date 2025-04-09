//
//  SummaryView.swift
//  echoWrite
//
//  Created by Sonal on 08/04/25.
//

import SwiftUI
import SwiftData

struct SummaryView: View {
    @Environment(\.modelContext) private var modelContext
    var summaryItem: SummaryItem
    
    @State var showFullTranscription: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(summaryItem.heading)
                .foregroundStyle(Color.primary)
                .font(.title3)
                .fontWeight(.semibold)
            
            ScrollView {
                Button {
                    showFullTranscription.toggle()
                } label: {
                    if showFullTranscription {
                        VStack {
                            Text("Transcription")
                                .foregroundStyle(Color.secondary)
                                .font(.headline)
                            
                            Text(summaryItem.text)
                                .foregroundStyle(Color.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    } else {
                        VStack {
                            Text("Summary")
                                .foregroundStyle(Color.secondary)
                                .font(.headline)
                                                        
                            Group {
                                Text(summaryItem.text)
                                +
                                Text(".....")
                            }
                            .foregroundStyle(Color.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
    
}
