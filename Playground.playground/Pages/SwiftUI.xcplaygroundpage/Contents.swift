//: [← Previous (SpriteKit Example)](@previous)
let boardView = BoardView()

import SwiftUI
#if os(iOS)
let controller = UIHostingController(rootView: boardView)
#elseif os(macOS)
let controller = NSHostingView(rootView: boardView)
#endif

import PlaygroundSupport
PlaygroundSupport.PlaygroundPage.current.liveView = controller
