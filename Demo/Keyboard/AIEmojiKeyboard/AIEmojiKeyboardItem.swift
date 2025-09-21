//
//  AIEmojiKeyboardItem.swift
//  AIKeyboard
//
//  Created by Hammad Ashraf on 21/12/2024.
//

import SwiftUI
import KeyboardKit

/**
 This view can be used in an ``EmojiKeyboard`` to display an
 emoji based on a certain style.
 */
public struct AIEmojiKeyboardItem: View {

    /**
     Create an emoji keyboard item.

     - Parameters:
       - emoji: The emoji to present.
       - style: The style to use.
     */
    public init(
        emoji: Emoji,
        style: Emoji.KeyboardStyle
    ) {
        self.emoji = emoji
        self.style = style
    }
    
    private let emoji: Emoji
    private let style: Emoji.KeyboardStyle
    
    public var body: some View {
        Text(emoji.char)
            .font(style.itemFont)
    }
}

struct EmojiKeyboardItem_Previews: PreviewProvider {
    
    static var previews: some View {
        AIEmojiKeyboardItem(
            emoji: Emoji("😜"),
            style: Emoji.KeyboardStyle()
        )
    }
}
