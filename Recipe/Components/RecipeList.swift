import SwiftUI
import RealmSwift

struct RecipeList: View {
    
    @Environment(\.realm) private var realm
    @ObservedResults(Recipe.self) var recipes: Results<Recipe>
    @Environment(\.editMode) var editMode
    
    var body: some View {
        VStack {
            HStack {
                Text("\(recipes.count) \(recipes.count > 1 ? "recipes" : "recipe")")
                    .font(.headline)
                    .fontWeight(.medium)
                    .opacity(0.7)
                
                Spacer()
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15) {
                ForEach(recipes, id: \._id) { recipe in
                    ZStack(alignment: .topTrailing) {
                        NavigationLink(destination: RecipeView(recipe: recipe)) {
                            RecipeCard(recipe: recipe)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        if editMode?.wrappedValue == .active {
                            Button(action: {
                                deleteRecipe(recipe)
                            }) {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: "minus")
                                            .foregroundColor(.white)
                                            .font(.system(size: 16, weight: .bold))
                                    )
                            }
                            .padding([.top, .trailing], 8)
                            .transition(.scale)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .padding(.horizontal)
    }
    
    private func deleteRecipe(_ recipe: Recipe) {
        guard let recipeToDelete = realm.object(ofType: Recipe.self, forPrimaryKey: recipe._id) else {
            return
        }
        $recipes.remove(recipeToDelete)
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        RecipeList()
    }
}
