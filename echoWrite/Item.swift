//
//  Item.swift
//  echoWrite
//
//  Created by Sonal on 03/04/25.
//

import Foundation
import SwiftData

@Model
final class SummaryItem {
    var timestamp: Double
    var heading: String
    var summary: String
    var text: String
    
    init(timestamp: Date, heading: String, summary: String, text: String) {
        self.timestamp = timestamp.timeIntervalSince1970
        self.heading = heading
        self.summary = summary
        self.text = text
    }
}
