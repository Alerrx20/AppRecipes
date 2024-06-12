import SwiftUI
import RealmSwift

struct HomeView: View {
    @ObservedRealmObject var recipes: Recipes
    
    var body: some View {
        NavigationView {
            List {
                ForEach(recipes.recipes) { recipe in
                    Text("\(recipe.name)")
                }
            }
        }
        .navigationViewStyle(.stack)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let realm = realmWithData()
        return HomeView(recipes:realm.objects(Recipes.self).first!)
        .environment(\.realm, realm)
    }
}
