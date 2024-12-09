import SwiftUI
import RealmSwift

struct CategoriesView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(Category.allCases) { category in
                    Text(category.rawValue + "s")
                }
            }
            .navigationTitle("Categories")
        }
        .navigationViewStyle(.stack)
        
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
