import SwiftUI
import RealmSwift
import UIKit

struct CreateRecipeView: View {
    @State private var recipeName = ""
    @State private var instructions = ""
    @State private var ingredient = ""
    @State private var ingredients: [String] = []
    //@Binding var userLogged: User
    @EnvironmentObject var userAuth: UserAuth
    
    @Environment(\.realm) private var realm
    
    @State private var selectedImage: UIImage? // Cambia a UIImage
    // Agrega una variable para controlar si se muestra el selector de imágenes
    @State private var showImagePicker = false
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("Recipe Name", text: $recipeName)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
            
            Text("Instructions:")
                .font(.headline)
                .padding(.horizontal)
            
            TextEditor(text: $instructions)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 2)
            
            HStack {
                TextField("Ingredient", text: $ingredient)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 2)
                
                Button("Add Ingredient") {
                    if !ingredient.isEmpty {
                        ingredients.append(ingredient)
                        ingredient = ""
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .shadow(radius: 2)
            }
            .padding()
            
            List(ingredients, id: \.self) { ingredient in
                Text(ingredient)
            }
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 2)
            
            
            
            Button("Select Image") {
                            // Al hacer clic en el botón, muestra el selector de imágenes
                            showImagePicker = true
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .sheet(isPresented: $showImagePicker) {
                            // Presenta el controlador de selección de imágenes
                            ImagePicker(image: $selectedImage)
                        }
                        
                        if let selectedImage = selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 300)
                        }

            
            
            
            
            Button("Save Recipe") {
                createRecipe(user: userAuth.userLogged!)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .shadow(radius: 2)
        }
        .padding()
        .navigationBarTitle("Create Recipe")
    }
    
    private func createRecipe(user: User) {
        DispatchQueue.main.async {
            let mongoClient = user.mongoClient("mongodb-atlas")
            let database = mongoClient.database(named: "RecipeApp")
            let collection = database.collection(withName: "Recipe")
            
            let recipe = Recipe()
            recipe.name = "Receta 1"
            recipe.instructions = "Instrucciones de la receta"
            let ingredients: [String] = ["Tomate", "Cebolla", "Pimiento", "Aceite de oliva", "Sal"]
            recipe.ingredients.append(objectsIn: ingredients)
            do {
                recipe.owner_id = try ObjectId(string: "6605fa6fd34a24c52ab85ae6")
            } catch {
                print("Error al convertir el objectId")
            }
            //Convert image to NSData to store in Realm
            print("Convirtiendo img")
            let img = selectedImage?.jpegData(compressionQuality: 0.9)
            recipe.image = img ?? Data()
            print(recipe.image)
            print(recipe.bson)
            // Insert the document into the collection
            collection.insertOne(recipe.bson) { result in
                switch result {
                    case .failure(let error):
                        print("Call to MongoDB failed: \(error.localizedDescription)")
                        return
                    case .success(let objectId):
                        // Success returns the objectId for the inserted document
                        print("Successfully inserted a document with id: \(objectId)")
                }
            }
        }
    }
}

//struct CreateRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateRecipeView()
//    }
//}
