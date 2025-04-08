//
//  Item.swift
//  echowrite
//
//  Created by Sonal on 08/04/25.
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
