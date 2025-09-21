//
//  EmojiCategoryTitle.swift
//  AIKeyboard
//
//  Created by Hammad Ashraf on 21/12/2024.
//

import SwiftUI
import KeyboardKit

/**
 [DEPRECATED] This will be made internal in KeyboardKit 8.0.
 
 This view renders a standard title for an emoji category.
 */
public struct EmojiCategoryTitle: View {
    
    public init(
        title: String,
        style: Emoji.KeyboardStyle
    ) {
        self.title = title
        self.style = style
    }
    
    private let title: String
    private let style: Emoji.KeyboardStyle
    
    public var body: some View {
        HStack {
            Text(title)
                .font(style.categoryTitleFont)
                .bold()
                .textCase(.uppercase)
                .opacity(0.4)
            Spacer()
        }
    }
}

struct EmojiCategoryTitle_Previews: PreviewProvider {
    
    static var previews: some View {
        EmojiCategoryTitle(
            title: "Hej",
            style: Emoji.KeyboardStyle())
    }
}
