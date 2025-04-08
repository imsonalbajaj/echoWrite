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
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading) {
                Text(summaryItem.heading)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                ScrollView {
                    if showFullTranscription {
                        Text("Transcription")
                            .font(.headline)
                        
                        Text(summaryItem.text)
                    } else {
                        Text("Summary")
                            .font(.headline)
                        
                        Text(summaryItem.text)
                    }
                }
                
                
                Spacer()
            }
            .padding()
            
            Button {
                showFullTranscription.toggle()
            } label: {
                Image.getSystemImage(showFullTranscription ? .arrowshape_right_fill : .arrowshape_left)
                    .foregroundStyle(Color(showFullTranscription ? CustomColor.greenBorder.rawValue : CustomColor.dark216.rawValue))
            }
        }
    }
}
