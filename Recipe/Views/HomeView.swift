import SwiftUI
import RealmSwift

struct HomeView: View {
    
    @StateObject private var realmManager = RealmManager.shared
    
    var body: some View {
        TabView {
            NavigationView {
                ScrollView {
                    RecipeList()
                }
                .navigationTitle("My Recipes")
                .navigationBarItems(trailing: EditButton())
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Log out") {
                            Task {
                                print("logout")
                                do {
                                    try await realmManager.logout()
                                } catch {
                                    let errorMessage = error.localizedDescription
                                    print(errorMessage)
                                }
                            }
                        }
                    }
                }
            }
            .navigationViewStyle(.stack)
            .tabItem {
                Label("Home", systemImage: "house")
            }
            
            CreateRecipeView()
                .tabItem {
                   Label("Create", systemImage: "plus")
                }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        return HomeView()
    }
}
