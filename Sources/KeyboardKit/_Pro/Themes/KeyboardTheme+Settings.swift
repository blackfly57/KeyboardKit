//
//  KeyboardTheme+Settings.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2024-10-27.
//  Copyright © 2024-2025 Daniel Saidi. All rights reserved.
//

import Foundation
import SwiftUI

/// 👑 This is unlocked by KeyboardKit Pro.
public class KeyboardThemeSettings: ObservableObject {
    
    public init() {}
    
    public static var settingsPrefix: String {
        KeyboardSettings.storeKeyPrefix(for: "themes")
    }
    
    /// The current theme storage value, if any.
    @AppStorage("\(settingsPrefix)theme", store: .keyboardSettings)
    public var themeValue: Keyboard.StorageValue<KeyboardTheme?> = .init(value: nil)

    /// 👑 This is unlocked by KeyboardKit Pro.
    public var theme: KeyboardTheme? { themeValue.value }
}
