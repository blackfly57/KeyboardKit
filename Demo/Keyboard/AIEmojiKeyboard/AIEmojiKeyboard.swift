//
//  AIEmojiKeyboard.swift
//  AIKeyboard
//
//  Created by Hammad Ashraf on 21/12/2024.
//

import SwiftUI
import KeyboardKit

/**
 This view can be used as an emoji keyboard and will list an
 emoji collection in a grid using the provided configuration.

 You can customize the emoji views in the keyboard, by using
 the `button` initializer. The initializer without a `button`
 parameter will use an ``EmojiKeyboardItem`` for every emoji.

 Note that this keyboard only lists the provided emojis. Use
 an ``EmojiCategoryKeyboard`` if you want surrounding titles
 and actions as in the iOS emoji keyboard.
 */
public struct AIEmojiKeyboard<ButtonView: View>: View {

    /**
     Create an emoji keyboard.

     - Parameters:
       - emojis: The emojis to include in the menu.
       - actionHandler: The action handler to use.
       - calloutContext: The callout context to affect, if any.
       - style: The style to apply to the keyboard, by default ``EmojiKeyboardStyle/standardPhonePortrait``.
       - button: A emoji keyboard button builder function.
     */
    public init(
        emojis: [Emoji],
        actionHandler: KeyboardActionHandler,
        calloutContext: KeyboardCalloutContext?,
        style: Emoji.KeyboardStyle = Emoji.KeyboardStyle(),
        scrollState: GestureButtonScrollState?,
        button: @escaping ButtonBuilder<ButtonView>
    ) {
        let gridItem = GridItem(.fixed(style.itemSize), spacing: style.verticalItemSpacing - 8)
        self.emojis = emojis
        self.rows = Array(repeating: gridItem, count: style.rows)
        self.actionHandler = actionHandler
        self.calloutContext = calloutContext
        self.style = style
        self.buttonBuilder = button
        self.scrollState = scrollState
    }

    /**
     Create an emoji keyboard that applies a standard button
     for every emoji in the provided collection.

     - Parameters:
       - emojis: The emojis to include in the menu.
       - actionHandler: The action handler to use.
       - calloutContext: The callout context to affect, if any.
       - style: The style to apply to the keyboard, by default ``EmojiKeyboardStyle/standardPhonePortrait``.
     */
    init(
        emojis: [Emoji],
        actionHandler: KeyboardActionHandler,
        calloutContext: KeyboardCalloutContext?,
        style: Emoji.KeyboardStyle = Emoji.KeyboardStyle(),
        scrollState: GestureButtonScrollState?
    ) where ButtonView == AIEmojiKeyboardItem {
        self.init(
            emojis: emojis,
            actionHandler: actionHandler,
            calloutContext: calloutContext,
            style: style,
            scrollState: nil,
            button: { AIEmojiKeyboardItem(emoji: $0, style: $1) }
        )
    }
    
    private let emojis: [Emoji]
    private let rows: [GridItem]
    private let actionHandler: KeyboardActionHandler
    private let calloutContext: KeyboardCalloutContext?
    private let style: Emoji.KeyboardStyle
    private let buttonBuilder: ButtonBuilder<ButtonView>
    private let scrollState: GestureButtonScrollState?
    
    /**
     This typealias represents functions that can be used to
     create an emoji button.
     */
    public typealias ButtonBuilder<EmojiButton: View> = (Emoji, Emoji.KeyboardStyle) -> EmojiButton
    
   
    
    public var body: some View {
        LazyHGrid(rows: rows, spacing: style.horizontalItemSpacing) {
            ForEach(emojis) { emoji in
                buttonView(
                    for: emoji,
                    style: style
                )
                .keyboardButtonGestures(
                    for: .emoji(emoji),
                    actionHandler: actionHandler,
                    calloutContext: calloutContext,
                    scrollState: scrollState
                )
            }
        }
        .padding(.horizontal)
        .frame(height: style.totalHeight - 8)
        .background(Color.clearInteractable)
    }
}

private extension AIEmojiKeyboard {

    func buttonView(for emoji: Emoji, style: Emoji.KeyboardStyle) -> some View {
        buttonBuilder(emoji, style)
            .accessibilityLabel(emoji.unicodeName)
            .accessibilityIdentifier(emoji.unicodeIdentifier ?? "")
    }
}

public extension AIEmojiKeyboard {
    
    /**
     This typealias represents an emoji-based action.
     */
    typealias EmojiAction = (Emoji) -> Void

    /**
     The standard action to use when tapping an emoji button.
     */
    static func standardEmojiView(
        for emoji: Emoji,
        style: Emoji.KeyboardStyle
    ) -> some View {
        AIEmojiKeyboardItem(emoji: emoji, style: style)
    }
}

struct EmojiKeyboard_Previews: PreviewProvider {
    
    static var previews: some View {
        ScrollView(.horizontal) {
            AIEmojiKeyboard(
                emojis: Array(Emoji.all),
                actionHandler: .preview,
                calloutContext: .preview, scrollState: nil
            )
        }
    }
}
