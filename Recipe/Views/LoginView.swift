//
//  LoginView.swift
//  Recipe
//
//  Created by Francisco Real on 28/10/23.
//

import SwiftUI
import RealmSwift

struct LoginView: View {
    @Binding var username: String
    @State private var email = ""
    @State private var password = ""
    
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
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 27.5)
        .background(
            LinearGradient(gradient: Gradient(colors: [.white, .orange]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            )
        
        
    }
    
    private func login() async {
        do {
            let email = self.email
            let password = self.password
            print("Email: " ,email, "Contra:", password)
            let user = try await realApp.login(credentials: Credentials.emailPassword(email: email, password: password))
            print("Successfully logged in as user \(user)")
            print("User id: \(user.id), User profile: \(user)")

            username = user.id
        } catch {
            print("Failed to login to Realm: \(error.localizedDescription)")
        }
    }

}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
      LoginView(username: .constant(""))
  }
}
