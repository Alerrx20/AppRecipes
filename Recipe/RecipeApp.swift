import SwiftUI

@main
struct RecipeApp: App {
    @StateObject private var realmManager = RealmManager.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if let user = realmManager.user, realmManager.realm != nil {
                    ContentView()
                        .environment(\.realmConfiguration, realmManager.configuration!)
                        .environment(\.realm, realmManager.realm!)
                } else {
                    LoginView()
                        .environmentObject(realmManager)
                }
            }
            .task {
                if let user = realmManager.app.currentUser {
                    realmManager.user = user
                    do {
                        try await realmManager.initialize()
                    } catch {
                        print("Failed to initialize Realm: \(error)")
                    }
                }
            }
        }
    }
}
