//
//  KeyboardThemesPreviewItemView.swift
//  Demo
//
//  Created by Hammad Ashraf on 21/09/2025.
//  Copyright © 2025 Daniel Saidi. All rights reserved.
//

import SwiftUI
import KeyboardKit


struct KeyboardThemesPreviewItemView: View {
    
    let theme: KeyboardTheme
    let action = KeyboardAction.character("A")
    var itemSize = KeyboardLayout.ItemSize(width: .points(110), height: 110)
    
    @State
    var keyboardContext: KeyboardContext = {
        let context = KeyboardContext()
        context.locales = .keyboardKitSupported
        //context.settings.addedLocales = [.english, .swedish, .finnish]
        context.localePresentationLocale = .english
        //context.spaceLongPressBehavior = .moveInputCursorWithLocaleSwitcher
        return context
    }()
    
    
    var body: some View {
        
        KeyboardViewItem(
            item: .init(
                action: action,
                size: itemSize,
                alignment: .center,
                edgeInsets: .init(top: 10, leading: 10, bottom: 10, trailing: 10)
            ),
            actionHandler: .preview,
            styleService: KeyboardStyle.CustomThemeBasedStyleService.customThemeBased(theme: theme, keyboardContext: keyboardContext),
            keyboardContext: keyboardContext,
            calloutContext: .preview,
            keyboardWidth: 110,
            inputWidth: 110,
            isGestureAutoCancellable: false,
            content: Text("A")
        )
        .background {
            theme.backgroundStyle?.backgroundColor
            if let backgroundGradient = theme.backgroundStyle?.backgroundGradient {
                LinearGradient(colors: backgroundGradient, startPoint: .top, endPoint: .bottom)
            }
        }
        .cornerRadius(12)
    }
}
