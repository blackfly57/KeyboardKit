//
//  EmojiCategoryKeyboard.swift
//  AIKeyboard
//
//  Created by Hammad Ashraf on 21/12/2024.
//

import SwiftUI
import KeyboardKit

/**
 This keyboard lists all emojis from a selected category, as
 well as a menu that lets the user select a new category and
 change back to an alphabetic keyboard.
 
 As long as the view requires iOS 14, the extensions must be
 kept in the main struct body for the previews to compile.
 */
public struct AIEmojiCategoryKeyboard: View {
    
    /**
     Create an emoji category keyboard.
     
     - Parameters:
       - selection: The currently selected category.
       - categories: The categories to show in the menu.
       - actionHandler: The action handler to use.
       - keyboardContext: The context to use when rendering the view.
       - calloutContext: The callout context to affect, if any.
       - style: The style to apply to the keyboard, by default `.standardPhonePortrait`.
       - styleProvider: The style provider to apply to the menu.
       - categoryTitle: A category title provider, by default category title.
     */
    public init(
        selection: EmojiCategory? = nil,
        categories: [EmojiCategory] = EmojiCategory.standard,
        actionHandler: KeyboardActionHandler,
        keyboardContext: KeyboardContext,
        calloutContext: KeyboardCalloutContext?,
        style: Emoji.KeyboardStyle = Emoji.KeyboardStyle(),
        styleProvider: KeyboardStyleService,
        categoryTitle: @escaping CategoryTitleProvider = { $0.emojiIcon }
    ) {
        self.initialSelection = selection
        self.categories = categories.filter { $0.emojis.count > 0 }
        self.actionHandler = actionHandler
        self.keyboardContext = keyboardContext
        self.calloutContext = calloutContext
        self.styleProvider = styleProvider
        self.style = style
        self.categoryTitle = categoryTitle
    }
    
    private let initialSelection: EmojiCategory?
    private let categories: [EmojiCategory]
    private let actionHandler: KeyboardActionHandler
    private let keyboardContext: KeyboardContext
    private let calloutContext: KeyboardCalloutContext?
    private let style: Emoji.KeyboardStyle
    private let styleProvider: KeyboardStyleService
    private let categoryTitle: CategoryTitleProvider
    
    @State
    private var isInitialized = false

    @State
    private var isSearchFocused = false

    @State
    private var query = ""

    @State
    private var selection = EmojiCategory.smileysAndPeople
    
    @StateObject private var scrollState = GestureButtonScrollState()
    
    
    // MARK: - Typealiases
    
    /**
     This is a typealias for a function that can be used for
     providing a title for an emoji category.
     */
    public typealias CategoryTitleProvider = (EmojiCategory) -> String

    
    // MARK: - Public Static Builders
    
    /**
     This function returns the standard title for a category.
     */
    public static func standardCategoryTitle(for category: EmojiCategory) -> String {
        category.emojiIcon
    }
    

    // MARK: - Private Functions
    
    private var defaults: UserDefaults { .standard }
    
    private let defaultsKey = "com.keyboardkit.EmojiCategoryKeyboard.category"
    
    private var persistedCategory: EmojiCategory {
        let name = defaults.string(forKey: defaultsKey) ?? ""
        return categories.first { $0.emojiIcon == name } ?? .smileysAndPeople
    }
    
    private func initialize() {
        if isInitialized { return }
        selection = initialSelection ?? persistedCategory
        isInitialized = true
    }
    
    private func saveCurrentCategory() {
        guard isInitialized else { return }
        defaults.set(selection.id, forKey: defaultsKey)
    }
    
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: style.verticalCategoryStackSpacing) {
            title
            keyboard
            menu
        }
        .onAppear(perform: initialize)
        .onChange(of: selection) { _ in saveCurrentCategory() }
    }
}


// MARK: - Private View Extensions

private extension AIEmojiCategoryKeyboard {
    
    var title: some View {
        EmojiCategoryTitle(
            title: selection.title,
            style: style
        )
        .padding(.horizontal)
        .padding(style.categoryTitlePadding)
    }

    var keyboard: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            AIEmojiKeyboard(
                emojis: selection.emojis.matching(query, in: keyboardContext.locale),
                actionHandler: actionHandler,
                calloutContext: calloutContext,
                style: style,
                scrollState: scrollState
            )
        }
        .id(selection)
        .scrollGestureState(scrollState)

    }
    
    var menu: some View {
        AIEmojiCategoryKeyboardMenu(
            selection: $selection,
            categories: categories,
            keyboardContext: keyboardContext,
            actionHandler: actionHandler,
            style: style,
            styleProvider: styleProvider
        )
    }
}

@available(iOS 15.0, *)
struct EmojiCategoryKeyboard_Previews: PreviewProvider {

    struct Preview: View {

        var body: some View {
            AIEmojiCategoryKeyboard(
                selection: .activity,
                actionHandler: .preview,
                keyboardContext: .preview,
                calloutContext: .preview,
                //style: .standardPhone,
                styleProvider: .preview
            ).background(Color.keyboardBackground)
        }
    }

    static var previews: some View {
        Preview()
            // .previewInterfaceOrientation(.landscapeLeft)
    }
}

public extension EmojiCategory {
    var title: String {
        switch self {
        case .frequent: return "Frequently Used"
        case .smileysAndPeople: return "Smileys & People"
        case .animalsAndNature: return "Animals & Nature"
        case .foodAndDrink: return "Food & Drink"
        case .activity: return "Activity"
        case .travelAndPlaces: return "Travel & Places"
        case .objects: return "Objects"
        case .symbols: return "Symbols"
        case .flags: return "Flags"
        case .favorites:
            return "Favorites"
        case .custom(id: let id, name: let name, emojis: let emojis, iconName: let iconName):
            return ""
        case .recent:
            return "Recent"
        }
    }
}
