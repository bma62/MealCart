//
//  LogIn.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-26.
//

import SwiftUI

struct LogInView: View {
    
    let lightGrey = Color(red: 239/255, green: 243/255, blue: 244/255)
    
    @EnvironmentObject var session: SessionStore
    
    @State var email = ""
    @State var password = ""
    @State var loading = false
    @State var error = ""
    
    func logIn() {
        loading = true
        session.logIn(email: email, password: password) { (result, error) in
            self.loading = false
            if let error = error {
                self.error = error.localizedDescription
            } else {
                self.email = ""
                self.password = ""
                self.error = ""
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to MealCart!")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .cornerRadius(25)
                    .padding(.bottom, 75)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder())
                    .background(lightGrey)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 5).strokeBorder())
                    .background(lightGrey)
                    .padding(.bottom, 20)
                
                Button(action: logIn) {
                    Text("Log In")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                        .background(Color.green)
                        .font(.title2)
                        .cornerRadius(5)
                        .frame(height: 50)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        
                }
                
                if (error != "") {
                    Text(error)
                        .font(.title3)
                }
                
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
//                        .foregroundColor(.white)
                        .cornerRadius(5)
                }

            }
            .padding()
        }
    }

}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
            .environmentObject(SessionStore())
    }
}
