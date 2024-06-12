import SwiftUI

struct RegisterView: View {
    @Binding var isRegisterViewPresented: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var isEmailValid = true

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                            Spacer()
                            Button(action: {
                                isRegisterViewPresented = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                            .padding()
                        }
            
            Text("Register")
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
                .background(isEmailValid ? Color.white : Color.red.opacity(0.3))
                .cornerRadius(20.0)
                .padding(.horizontal, 20)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .onChange(of: email) { newValue in
                    isEmailValid = isValidEmail(email: newValue)
                }
            
            SecureField("Password", text: self.$password)
                .padding()
                .background(Color.white)
                .cornerRadius(20.0)
                .padding(.horizontal, 20)
            
            Button(action: { Task {await register()} }) {
                Text("Register")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.green)
                    .cornerRadius(15.0)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 27.5)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            )
        .alert(isPresented: $showAlert) {
                    if alertMessage == "success" {
                        return Alert(title: Text("Usuario Creado"), message: Text("El usuario ha sido creado correctamente"), dismissButton: .default(Text("OK")) {
                            isRegisterViewPresented = false
                        })
                    } else {
                        return Alert(title: Text("Error al registrar"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                }
    }
    
    private func register() async {
        guard isEmailValid else {
            alertMessage = "Ingrese un email válido"
            showAlert = true
            return
        }
        do {
            let email = self.email
            let password = self.password
            print("Email: " ,email, "Contra:", password)
            try await realApp.emailPasswordAuth.registerUser(email: email, password: password)
            print("Successfully registered user.")
            showAlert = true
            alertMessage = "success"
        } catch {
            showAlert = true
            alertMessage = error.localizedDescription;
            print("Failed to register: \(error.localizedDescription)")
        }
    }
    
    private func isValidEmail(email: String) -> Bool {
            // Expresión regular para verificar un email
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(isRegisterViewPresented: .constant(false))
    }
}
