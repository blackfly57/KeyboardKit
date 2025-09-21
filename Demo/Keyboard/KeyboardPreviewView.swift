//
//  KeyboardPreviewView.swift
//  KeyboardTest
//
//  Created by Hammad Ashraf on 11/02/2025.
//

import SwiftUI
import KeyboardKit

struct KeyboardPreviewView: View {

    var controller: KeyboardInputViewController = {
        let controller = KeyboardInputViewController.preview
        
        let context = controller.state.keyboardContext
        context.locale = .english
        //context.settings.addedLocales = [.english, .swedish, .persian]
        context.settings.keyboardDockEdge = .none
//            context.spaceLongPressBehavior = .openLocaleContextMenu
//            context.spaceLongPressBehavior = .moveInputCursorWithLocaleSwitcher
        
//        controller.state.autocompleteContext.suggestions = [
//            .init(text: "Foo"),
//            .init(text: "Bar", type: .autocorrect),
//            .init(text: "Baz")
//        ]
        
        
        controller.services.styleService = try! .customThemeBased(
            keyboardContext: context,
            themeContext: controller.state.themeContext
        )
        
        controller.state.themeContext.currentTheme = KeyboardTheme.aestheticTheme
        return controller
    }()
    
    var keyboardContext: KeyboardContext {
        controller.state.keyboardContext
    }
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var dockEdge: Keyboard.DockEdge? = nil
    
    var body: some View {
        VStack {
            Spacer()
            KeyboardView(
                state: controller.state,
                services: controller.services,
                renderBackground: true,
                buttonContent: { $0.view },
                buttonView: { $0.view },
                collapsedView: { $0.view },
                emojiKeyboard: { $0.view },
                toolbar: { $0.view }
            )
        }
        
//            KeyboardView(
//                state: controller.state,
//                services: controller.services,
//                buttonContent: { param in
//                    switch param.item.action {
//                    case .backspace:
//                        Image(systemName: "trash").foregroundColor(Color.red)
//                    default: param.view
//                    }
//                },
//                buttonView: { param in
//                    switch param.item.action {
//                    case .space:
//                        Text("This is a space bar replacement")
//                            .frame(maxWidth: .infinity)
//                            .multilineTextAlignment(.center)
//                    default: param.view
//                    }
//                },
//                collapsedView: { _ in
//                    Color.red.frame(height: 100)
//                },
//                emojiKeyboard: { _ in
//                    Button {
//                        controller.state.keyboardContext.keyboardType = .alphabetic
//                    } label: {
//                        Color.orange
//                            .overlay(Text("Not implemented"))
//                    }
//                },
//                toolbar: { $0.view }
//            )
//            .keyboardDockEdge(dockEdge)
    }
}

#Preview {
    return KeyboardPreviewView()
}
