//
//  Extensions.swift
//  echoWrite
//
//  Created by Sonal on 04/04/25.
//

import UIKit
import SwiftUI

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

extension Image {
    static func getSystemImage(_ systemImage: SystemImage) -> Image {
        return Image(systemName: systemImage.rawValue)
    }
}
