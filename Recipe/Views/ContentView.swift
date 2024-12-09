import SwiftUI
import RealmSwift

struct ContentView: View {
    
    @State private var recipeName = ""
    @ObservedResults(Recipe.self) var recipes: Results<Recipe>
    
    var body: some View {
        NavigationView {
            HomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
