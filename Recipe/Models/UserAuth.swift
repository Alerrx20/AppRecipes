import SwiftUI
import RealmSwift

class UserAuth: ObservableObject {
    @Published var userLogged: User?

    static let shared = UserAuth()
    
    private init() {
        self.userLogged = nil
    }
}
