//
//  KeyboardThemeAesthetic.swift
//  KeyboardTest
//
//  Created by Hammad Ashraf on 13/02/2025.
//

import KeyboardKit
import SwiftUI

extension KeyboardTheme {
    
    static var aestheticTheme: Self {
        get {
            let background = Keyboard.Background.init(backgroundColor: Color(hex: "ABA09B"))
            
            let shadow = Keyboard.ButtonStyle.ShadowStyle(color: Color(hex: "#726D67"), size: 3)
            
            let buttonStyle = Keyboard.ButtonStyle(backgroundColor: Color(hex: "908172"), foregroundColor: Color(hex: "504235"), cornerRadius: 6, shadow: shadow)
            var style = [KeyboardTheme.ButtonType.input: buttonStyle]
            
            style[.primary] = Keyboard.ButtonStyle(backgroundColor: Color(hex: "504235"), foregroundColor: .white, cornerRadius: 6, shadow: shadow, pressedOverlayColor: .white.opacity(0.4))
            style[.system] = Keyboard.ButtonStyle(backgroundColor: Color(hex: "BBCCD1"), foregroundColor: Color(hex: "54473A"), cornerRadius: 6, shadow: shadow, pressedOverlayColor: .white.opacity(0.4))
            
            var callOut = Callouts.CalloutStyle.standard
            callOut.backgroundColor = Color(hex: "908172")
            callOut.foregroundColor = Color(hex: "504235")
            
            var standardToolBar = Autocomplete.ToolbarStyle.standard
            standardToolBar.item.titleColor = Color(hex: "504235")
            
            return Self(name: "aestheticTheme", collectionName: "Aesthetic", backgroundStyle: background, buttonStyles: style,autocompleteToolbarStyle: standardToolBar, calloutStyle: callOut)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (r, g, b, a) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
