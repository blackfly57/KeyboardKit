//
//  EmojiCategoryKeyboardMenu.swift
//  KeyboardKit
//
//  Created by Daniel Saidi on 2021-01-17.
//  Copyright © 2021-2023 Daniel Saidi. All rights reserved.
//

import SwiftUI
import KeyboardKit
/**
 [DEPRECATED] This will be made internal in KeyboardKit 8.0.
 
 This menu can be used to list a set of emoji categories and
 let each category button toggle a category selection.
 
 The menu buttons are also surrounded by a keyboard switcher
 and a backspace.
 
 As long as the view requires iOS 14, the extensions must be
 kept in the main struct body for the previews to compile.
 */
public struct AIEmojiCategoryKeyboardMenu: View {
    
    /**
     Create an emoji category keyboard menu.
     
     - Parameters:
       - selection: The current selection.
       - categories: The categories to include in the menu.
       - keyboardContext: The context to bind the buttons to.
       - actionHandler: The action handler to use, by default the shared one.
       - style: The style to apply to the menu.
       - styleProvider: The style provider to apply to the menu.
     */
    public init(
        selection: Binding<EmojiCategory>,
        categories: [EmojiCategory] = EmojiCategory.standard,
        keyboardContext: KeyboardContext,
        actionHandler: KeyboardActionHandler,
        style: Emoji.KeyboardStyle,
        styleProvider: KeyboardStyleService
    ) {
        self.categories = categories.filter { $0.emojis.count > 0 }
        self.keyboardContext = keyboardContext
        self.actionHandler = actionHandler
        self._selection = selection
        self.style = style
        self.styleProvider = styleProvider
    }

    @Binding
    private var selection: EmojiCategory
    
    private let categories: [EmojiCategory]
    private let keyboardContext: KeyboardContext
    private let actionHandler: KeyboardActionHandler
    private let style: Emoji.KeyboardStyle
    private let styleProvider: KeyboardStyleService
    
    @State
    private var isInitialized = false
        
    public var body: some View {
        HStack(spacing: 0) {
            Spacer()
            keyboardSwitchButton.font(style.menuAbcFont)
            Spacer()
            buttonList.font(style.menuIconFont)
            Spacer()
            backspaceButton.font(style.menuIconFont)
            Spacer()
        }
    }
    
    
    // MARK: - Private Extensions
    
    private var backspaceButton: some View {
        let action = KeyboardAction.backspace
        let image = styleProvider.buttonImage(for: action)
        return image.keyboardButtonGestures(
            for: action,
            actionHandler: actionHandler,
            calloutContext: nil
        ).scaledToFill()
    }
    
    private var keyboardSwitchButton: some View {
        let action = KeyboardAction.keyboardType(.alphabetic)
        let text = styleProvider.buttonText(for: action) ?? "ABC"
        return Text(text).keyboardButtonGestures(
            for: action,
            actionHandler: actionHandler,
            calloutContext: nil
        ).scaledToFill()
    }
    
    private var buttonList: some View {
        ForEach(categories) {
            buttonListItem(for: $0)
        }
    }
    
    private func buttonListItem(for category: EmojiCategory) -> some View {
        Button(action: { selection = category }, label: {
            Text(category.emojiIcon)
                .padding(6)
                .background(selection == category ? style.menuSelectionColor : Color.clear)
                .clipShape(Circle())
                .padding(.vertical, 5)
        }).buttonStyle(.plain)
    }
    
    
}

struct EmojiCategoryKeyboardMenu_Previews: PreviewProvider {
    
    static var previews: some View {
        AIEmojiCategoryKeyboardMenu(
            selection: .constant(.activity),
            categories: .standard,
            keyboardContext: .preview,
            actionHandler: .preview,
            style: Emoji.KeyboardStyle(),
            styleProvider: .preview
        ).background(Color.gray)
    }
}
