//
//  ShoppingAppApp.swift
//  ShoppingApp
//
//  Created by Omidiora Emmanuel on 03/08/2026.
//

import SwiftUI

@main
struct ShoppingAppApp: App {
    @State private var  cartStore = CartStore()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(cartStore)
        }
    }
}
