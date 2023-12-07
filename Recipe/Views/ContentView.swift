import SwiftUI

struct Recipe: Identifiable, Codable {
    var id = UUID()
    var name: String
    var ingredients: [String]
    var instructions: String
    var category: String
}

class RecipeManager: ObservableObject {
    @Published var recipes: [Recipe] = []
    
    init() {
        loadRecipes() // Cargar recetas guardadas al inicializar el RecipeManager
    }
    
    // Método para agregar una nueva receta
    func addRecipe(recipe: Recipe) {
        recipes.append(recipe)
        saveRecipes() // Guardar recetas actualizadas
    }
    
    // Método para eliminar una receta
    func deleteRecipe(recipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes.remove(at: index)
            saveRecipes() // Guardar recetas actualizadas
        }
    }
    
    // Método para guardar las recetas en UserDefaults
    private func saveRecipes() {
        do {
            let data = try JSONEncoder().encode(recipes)
            UserDefaults.standard.set(data, forKey: "recipes")
        } catch {
            print("Error al guardar las recetas: \(error)")
        }
    }
    
    // Método para cargar las recetas desde UserDefaults
    private func loadRecipes() {
        if let data = UserDefaults.standard.data(forKey: "recipes") {
            do {
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                self.recipes = recipes
            } catch {
                print("Error al cargar las recetas: \(error)")
            }
        }
    }
}

struct RecipeListView: View {
    @EnvironmentObject var recipeManager: RecipeManager
    @State private var isCreatingRecipe = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipeManager.recipes) { recipe in
                    NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                        Text(recipe.name)
                    }
                }
                .onDelete(perform: deleteRecipe)
            }
            .navigationTitle("Recetas")
            .sheet(isPresented: $isCreatingRecipe) {
                CreateRecipeView()
                    .environmentObject(recipeManager)
            }
            .navigationBarItems(trailing:
                HStack {
                    Button(action: {
                        isCreatingRecipe = true
                    }) {
                        Text("Crear Receta")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    EditButton()
                }
            )
        }
    }
    
    private func deleteRecipe(at offsets: IndexSet) {
        offsets.forEach { index in
            let recipe = recipeManager.recipes[index]
            recipeManager.deleteRecipe(recipe: recipe)
        }
    }
}

struct RecipeDetailView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(recipe.name)
                .font(.title)
            Text("Ingredientes:")
                .font(.headline)
            Text(recipe.ingredients.joined(separator: ", "))
            Text("Instrucciones:")
                .font(.headline)
            Text(recipe.instructions)
            
            Spacer()
        }
        .padding()
        .navigationBarTitle(Text(recipe.name), displayMode: .inline)
    }
}

struct ContentView: View {
    @State private var username = ""
    
    var body: some View {
        NavigationView {
            if username == "" {
                LoginView(username: $username)
            } else {
                Text("Logged in \(username)")
                RecipeListView(recipeManager: <#T##EnvironmentObject<RecipeManager>#>)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
