import SwiftUI

struct LoginView: View {
    
    @StateObject var authManager = AuthenticationManager()
//    @Binding var username: String
    @State private var email = ""
    @State private var password = ""
    @State private var isRegisterViewPresented = false
//    @State private var alertMessage = ""
//    @State private var showAlert = false
    @State private var isEmailValid = true
    //@Binding var userLogged: User?
    //@EnvironmentObject var userAuth: UserAuth
    @StateObject private var realmManager = RealmManager.shared
    @State private var errorMessage: String?
    
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
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(20.0)
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(20.0)
                .padding(.horizontal, 20)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }
            
            Button(action: {
                Task {
                    do {
                        try await realmManager.login(email: email, password: password)
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            
//            if authManager.isLoading {
//                ProgressView()
//            }
//
//            if let error = authManager.errorMessage {
//                Text(error)
//                    .foregroundColor(.pink)
//            }
            
            
            VStack {
                Text("¿No estás registrado?")
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Button(action: {
                    Task {
                        do {
                            try await realmManager.register(email: email, password: password)
                            errorMessage = "User registered successfully! Please log in."
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
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
                
                Button(action: {
                    Task {
                        do {
                            try await realmManager.loginAnonymously()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                }) {
                    Text("Log in anonymously")
                }
                .disabled(authManager.isLoading)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 27.5)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            )
        
        
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(isLoggedIn: false)
//    }
//}
