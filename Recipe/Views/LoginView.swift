import SwiftUI
import RealmSwift
import Realm

struct LoginView: View {
    //@Binding var username: String
    @State private var email = ""
    @State private var password = ""
    @State private var isRegisterViewPresented = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isEmailValid = true
    //@Binding var userLogged: User?
    @EnvironmentObject var userAuth: UserAuth
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Recipe IOS App")
                .font(.largeTitle)
                .padding(.vertical, 40)
            
            Image("icon")
                .resizable()
                .frame(width: 250, height: 250)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .shadow(radius: 10)
                .padding(.bottom, 50)
            
            TextField("Email", text: self.$email)
                .padding()
                .background(Color.white)
                .cornerRadius(20.0)
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: self.$password)
                .padding()
                .background(Color.white)
                .cornerRadius(20.0)
                .padding(.horizontal, 20)
            
            Button(action: { Task {await login()} }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            VStack {
                Text("¿No estás registrado?")
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Button(action: {
                    isRegisterViewPresented = true
                }) {
                    Text("Register")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                }
                .sheet(isPresented: $isRegisterViewPresented) {
                    RegisterView(isRegisterViewPresented: $isRegisterViewPresented)
                }
                
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 27.5)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            )
        .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error al iniciar sesión"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
        
        
    }
    
    private func login() async {
        do {
            let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try await Realm(configuration: configuration)
            let email = self.email
            let password = self.password
            print("Email: " ,email, "Contra:", password)
            let user = try await realApp.login(credentials: Credentials.emailPassword(email: email, password: password))
            print("Successfully logged in as user \(user)")
            print("User id: \(user.id)")
            //username = user.id
            //userLogged = user
            userAuth.userLogged = user
        } catch {
            showAlert = true
            alertMessage = error.localizedDescription
            print("Failed to login to Realm: \(error.localizedDescription)")
        }
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

}
