//
//  CreateRecipeView.swift
//  Recipe
//
//  Created by Francisco Real on 28/10/23.
//

import SwiftUI

struct CreateRecipeView: View {
    @State private var name: String = ""
    @State private var ingredients: String = ""
    @State private var instructions: String = ""
    @State private var category: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var recipeManager: RecipeManager
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles de la receta")) {
                    TextField("Nombre", text: $name)
                    TextField("Ingredientes (separados por comas)", text: $ingredients)
                    TextField("Instrucciones", text: $instructions)
                    TextField("Categoría", text: $category)
                }
                
                Section {
                    Button("Guardar receta") {
                        saveRecipe()
                    }
                }
            }
            .navigationTitle("Nueva Receta")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func saveRecipe() {
        let recipe = Recipe(
            name: name,
            ingredients: ingredients.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) },
            instructions: instructions,
            category: category
        )
        
        recipeManager.addRecipe(recipe: recipe)
        presentationMode.wrappedValue.dismiss()
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView()
    }
}
