//
//  Item.swift
//  echoWrite
//
//  Created by Sonal on 03/04/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
