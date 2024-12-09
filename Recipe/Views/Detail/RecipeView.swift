import SwiftUI
import RealmSwift

struct RecipeView: View {
    var recipe: Recipe
    
    var body: some View {
        ScrollView {
            if let uiImage = UIImage(data: recipe.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400, height: 300, alignment: .center)
                    .clipped()
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundColor(.white.opacity(0.7))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack(spacing: 30) {
                Text(recipe.name)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 30) {
                    if !recipe.instructions.isEmpty {
                        Text("Instructions:")
                            .font(.headline)
                        Text(recipe.instructions)
                    }
                    
                    if !recipe.ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Ingredients")
                                .font(.headline)
                            ForEach(recipe.ingredients, id: \.self) { ingredient in
                                Text(ingredient)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}
