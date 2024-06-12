import SwiftUI
import RealmSwift

struct ContentView: View {
    @State private var username = ""
    @Binding var userLogged: User?
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        NavigationView {
            if userAuth.userLogged == nil {
                LoginView()
            } else {
                HomeView(recipes: Recipes())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userLogged: .constant(nil))
    }
}
