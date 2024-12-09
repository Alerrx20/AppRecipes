import Foundation
import RealmSwift

@MainActor
class RealmManager: ObservableObject {
    
    let app: App
    
    @Published var realm: Realm?
    static let shared = RealmManager()
    @Published var user: User?
    @Published var configuration: Realm.Configuration?
    
    private init() {
        self.app = App(id: "recipeapp-tzaxane")
    }
    
//    @MainActor
//    func initialize() async throws {
//
//        user = try await app.login(credentials: Credentials.anonymous)
//
//        self.configuration = user?.flexibleSyncConfiguration(initialSubscriptions: { subs in
//            if let _ = subs.first(named: "all-recipes") {
//                return
//            } else {
//                subs.append(QuerySubscription<Recipe>(name: "all-recipes"))
//            }
//        }, rerunOnOpen: true)
//
//        realm = try! await Realm(configuration: configuration!, downloadBeforeOpen: .always)
//    }
    
    
    func initialize() async throws {
        guard let user = app.currentUser else { return }
        print("----------------\(user)")
        self.user = user
        self.configuration = user.flexibleSyncConfiguration(initialSubscriptions: { subs in
            if let _ = subs.first(named: "user-recipes") {
                return
            } else {
                subs.append(QuerySubscription<Recipe>(
                    name: "user-recipes",
                    where: "owner_id == '\(user.id)'"
                ))
            }
        }, rerunOnOpen: true)
        
        realm = try await Realm(configuration: configuration!, downloadBeforeOpen: .always)
    }
    
        // MARK: - Registro
        func register(email: String, password: String) async throws {
            try await app.emailPasswordAuth.registerUser(email: email, password: password)
        }
        
        // MARK: - Inicio de Sesión con Email y Contraseña
        func login(email: String, password: String) async throws {
            self.user = try await app.login(credentials: .emailPassword(email: email, password: password))
            try await initialize()
        }
        
        // MARK: - Inicio de Sesión Anónimo
        func loginAnonymously() async throws {
            self.user = try await app.login(credentials: .anonymous)
            try await initialize()
        }
        
        // MARK: - Cerrar Sesión
        func logout() async throws {
            guard let user = app.currentUser else { return }
            try await user.logOut()
            self.user = nil
            self.realm = nil
    }
}
