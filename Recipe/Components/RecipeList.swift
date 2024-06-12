import SwiftUI
import RealmSwift

struct RecipeList: View {
    @ObservedRealmObject var recipes: Recipes
    
    var body: some View {
        VStack {
            HStack {
                Text("\(recipes.recipes.count) \(recipes.recipes.count > 1 ? "recipes" : "recipe")")
                    .font(.headline)
                    .fontWeight(.medium)
                    .opacity(0.7)
                
                Spacer()
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160), spacing: 15)], spacing: 15) {
                ForEach(recipes.recipes) { recipe in
                    RecipeCard(recipe: recipe)
                }
            }
            .padding(.top)
        }
        .padding(.horizontal)
    }
}

struct RecipeList_Previews: PreviewProvider {
    static var previews: some View {
        let realm = realmWithData()
        ScrollView{
            return RecipeList(recipes:realm.objects(Recipes.self).first!)
            .environment(\.realm, realm)
        }
    }
}
