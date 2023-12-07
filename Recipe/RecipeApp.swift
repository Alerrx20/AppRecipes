//
//  RecipeApp.swift
//  Recipe
//
//  Created by Francisco Real on 24/5/23.
//

import SwiftUI
import RealmSwift

let realApp = RealmSwift.App(id: "recipeapp-ilvlq")

@main
struct RecipeApp: SwiftUI.App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
