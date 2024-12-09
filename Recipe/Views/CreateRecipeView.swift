import SwiftUI
import RealmSwift
import UIKit

struct CreateRecipeView: View {
    
    @ObservedResults(Recipe.self) var recipes: Results<Recipe>
    @StateObject private var realmManager = RealmManager.shared

    @State private var recipeName = ""
    @State private var instructions = ""
    @State private var ingredient = ""
    @State private var ingredients: [String] = []
    @State private var selectedImage: UIImage?
    @State private var showImagePicker = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Create Recipe")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)
                
                Text("Name:")
                    .font(.headline)
                    .padding(.horizontal)
                
                TextField("Recipe Name", text: $recipeName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                
                Text("Instructions:")
                    .font(.headline)
                    .padding(.horizontal)
                
                TextEditor(text: $instructions)
                    .frame(height: 100)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                
                VStack(spacing: 10) {
                    TextField("Ingredient", text: $ingredient)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    
                    Button(action: {
                        if !ingredient.isEmpty {
                            ingredients.insert(ingredient, at: 0)
                            ingredient = ""
                        }
                    }) {
                        Text("Add Ingredient")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .shadow(radius: 2)
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(ingredients, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(8)
                                .shadow(radius: 2)
                            
                            Button(action: {
                                deleteIngredient(at: ingredient)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                VStack(spacing: 10) {
                    Text("Select an Image")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Button("Select Image") {
                        showImagePicker = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $selectedImage)
                    }
                }
                
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 10)
                }
                
                HStack {
                    Spacer()
                    Button("Save Recipe") {
                        create()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                }
            }
            .padding()
        }
        .navigationBarTitle("Create Recipe", displayMode: .inline)
    }
    
    private func deleteIngredient(at ingredientToRemove: String) {
        if let index = ingredients.firstIndex(of: ingredientToRemove) {
            ingredients.remove(at: index)
        }
    }
    
    private func create() {
        guard let userId = realmManager.user?.id else {
            print("Error: No user is logged in.")
            return
        }
        let recipe = Recipe()
        recipe.name = recipeName
        recipe.instructions = instructions
        recipe.ingredients.append(objectsIn: ingredients)
        let img = selectedImage?.jpegData(compressionQuality: 0.9)
        recipe.image = img ?? Data()
        recipe.owner_id = userId
        $recipes.append(recipe)
        
        recipeName = ""
        instructions = ""
        ingredients = []
        selectedImage = nil
    }
}

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView()
    }
}
