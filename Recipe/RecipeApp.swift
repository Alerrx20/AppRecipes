import SwiftUI
import RealmSwift

let realApp = RealmSwift.App(id: "recipeapp-ilvlq")

@main
struct RecipeApp: SwiftUI.App {
    @StateObject var userAuth = UserAuth.shared
    
    init() {
        Task.init {
            do {
                // Configuración de la Realm
                let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)

                // Abriendo la Realm de forma asíncrona
                _ = try await Realm(configuration: configuration)
            } catch {
                print("Error opening Realm: \(error.localizedDescription)")
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(userLogged: .constant(nil)).environmentObject(userAuth)
        }
    }
}
