//
//  CustomThemeBasedStyleService.swift
//  KeyboardTest
//
//  Created by Hammad Ashraf on 09/02/2025.
//
import KeyboardKit
import SwiftUI

public extension KeyboardStyleService where Self == KeyboardStyle.CustomThemeBasedStyleService {


    static func customThemeBased(
        keyboardContext: KeyboardContext,
        themeContext: KeyboardThemeContext
    ) throws -> Self {
        try KeyboardStyle.CustomThemeBasedStyleService.init(keyboardContext: keyboardContext, themeContext: themeContext)
    }
    
    static func customThemeBased(
        theme: @autoclosure () -> KeyboardTheme,
        keyboardContext: KeyboardContext
    ) -> Self {
        try! KeyboardStyle.CustomThemeBasedStyleService.init(keyboardContext: keyboardContext, theme: theme())
    }
}

extension KeyboardStyle {

    /// This class inherits applies theme-based overrides to
    /// standard styles.
    ///
    /// This service can also be resolved with the shorthand
    /// ``KeyboardStyleService/themeBased(theme:keyboardContext:)``.
    ///
    /// See <doc:Themes-Article> for more information.
    ///
    /// > Important: This requires that your license unlocks the
    /// ``ProFeature/themes`` feature.
    open class CustomThemeBasedStyleService : KeyboardKit.KeyboardStyle.StandardStyleService {

        /// Create dynamic a theme-based style provider.
        ///
        /// - Parameters:
        ///   - keyboardContext: The keyboard context to use.
        ///   - themeContext: The keyboard theme context to use.
        public init(keyboardContext: KeyboardKit.KeyboardContext, themeContext: KeyboardKit.KeyboardThemeContext) throws {
            self.themeContext = themeContext
            super.init(keyboardContext: keyboardContext)
        }
        
        public init(keyboardContext: KeyboardKit.KeyboardContext, theme: KeyboardKit.KeyboardTheme) throws {
            let context = KeyboardKit.KeyboardThemeContext()
            context.currentTheme = theme
            self.themeContext = context
            super.init(keyboardContext: keyboardContext)
        }

        /// The keyboard theme to use.
        public var themeContext: KeyboardKit.KeyboardThemeContext

        public var theme: KeyboardKit.KeyboardTheme {
            themeContext.currentTheme ?? KeyboardTheme(name: "test", collectionName: "test")
        }

        /// The background style to apply to the entire keyboard.
        override open var backgroundStyle: KeyboardKit.Keyboard.Background {
            themeContext.currentTheme?.backgroundStyle ?? .standard
        }

        /// The foreground color to apply to the entire keyboard.
        override open var foregroundColor: Color? {
            if keyboardContext.keyboardType == .emojis {
                return .primary
            }
            return theme.foregroundColor
        }

        /// The button style to use for a certain action.
        override open func buttonStyle(for action: KeyboardKit.KeyboardAction, isPressed: Bool) -> KeyboardKit.Keyboard.ButtonStyle {
            
            let standard = KeyboardKit.Keyboard.ButtonStyle.init(
                backgroundColor: buttonBackgroundColor(for: action, isPressed: isPressed),
                foregroundColor: buttonForegroundColor(for: action, isPressed: isPressed),
                font: buttonFont(for: action),
                keyboardFont: buttonKeyboardFont(for: action),
                cornerRadius: buttonCornerRadius(for: action),
                border: buttonBorderStyle(for: action),
                shadow: buttonShadowStyle(for: action)
            )
            
            switch action {
            case .primary(_):
                if var style = theme.buttonStyles[.primary] {
                    style.keyboardFont = buttonKeyboardFont(for: action)
                    return style
                }
                return standard
            case .backspace, .capsLock, .keyboardType(_), .shift(_):
                if var style = theme.buttonStyles[.system] {
                    style.keyboardFont = buttonKeyboardFont(for: action)
                    return style
                }
                return standard
            case .character(_), .characterMargin(_), .space:
                if var style = theme.buttonStyles[.input] {
                    style.keyboardFont = buttonKeyboardFont(for: action)
                    return style
                }
                return standard
            default:
                return standard
            }
            
            
        }

        /// The style to apply to ``Autocomplete/Toolbar`` views.
        open override var autocompleteToolbarStyle: KeyboardKit.Autocomplete.ToolbarStyle {
            theme.autocompleteToolbarStyle ?? .standard
        }
        /// The callout style to override the standard style with, if any.
        override open var calloutStyle: KeyboardKit.Callouts.CalloutStyle? {
            theme.calloutStyle ?? .standard
        }
        
        open override func buttonText(for action: KeyboardAction) -> String? {
            switch action {
            case .primary:
                if keyboardContext.locale.identifier == "ur_PK" {
                    return "⏎"
                }
                return super.buttonText(for: action)
            case .space:
                if keyboardContext.locale.identifier == "ur_PK" {
                    return "فاصلہ"
                }
                return super.buttonText(for: action)
                
            case .keyboardType(let type):
                if keyboardContext.locale.identifier == "ur_PK" {
                    switch type {
                    case .webSearch:
                        return "اب ج"
                    case .alphabetic:
                        return "اب ج"
                    case .email:
                        return "اب ج"
                    case .emojis:
                        return "اب ج"
                    case .emojiSearch:
                        return "اب ج"
                    case .images:
                        return "اب ج"
                    case .numberPad:
                        return "۱۲۳"
                    case .numeric:
                        return "۱۲۳"
                    case .symbolic:
                        return "#+="
                    case .url:
                        return "اب ج"
                    case .custom(named:  _):
                        return "اب ج"
                    }
                }
                return super.buttonText(for: action)
            default:
                return super.buttonText(for: action)
            }
        }
    }
}
