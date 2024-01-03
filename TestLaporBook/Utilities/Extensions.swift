//
//  Extensions.swift
//  TestLaporBook
//
//  Created by Muhammad Rakha' Naufal on 27/12/23.
//

import SwiftUI
import MapKit

// MARK: - Extension of Color
extension Color {
  init(hex: String) {
    var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
    hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
    
    var rgb: UInt64 = 0
    
    Scanner(string: hexSanitized).scanHexInt64(&rgb)
    
    let red = Double((rgb & 0xFF0000) >> 16) / 255.0
    let green = Double((rgb & 0x00FF00) >> 8) / 255.0
    let blue = Double(rgb & 0x0000FF) / 255.0
    
    self.init(red: red, green: green, blue: blue)
  }
}

// MARK: - Extension of String
extension String {
  init(date: Date, format: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = format
    self.init(formatter.string(from: date))
  }
}

