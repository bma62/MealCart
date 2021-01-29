//
//  SignUp.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-26.
//

import SwiftUI

struct SignUpView: View {
    
    // MARK: Properties
    
    let lightGrey = Color(red: 239/255, green: 243/255, blue: 244/255)
    
    @EnvironmentObject var session: SessionStore
    
    @State var email = ""
    @State var password = ""
    @State var error = ""
    
    // MARK: Sign Up Function
    
    func signUp() {
        session.signUp(email: email, password: password) { (result, error) in
            // if the error is not nil, read the error message
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
        VStack {
            Text("Create Account")
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
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .padding()
                .background(RoundedRectangle(cornerRadius: 5).strokeBorder())
                .background(lightGrey)
                .padding(.bottom, 20)
            
            SecureField("Password", text: $password)
                .padding()
                .background(RoundedRectangle(cornerRadius: 5).strokeBorder())
                .background(lightGrey)
                .padding(.bottom, 20)
            
            if (error != "") {
                Text(error)
                    .font(.caption2)
                    .foregroundColor(.red)
                    .offset(y: -10)
            }
                            
            Button(action: signUp) {
                Text("Sign Up")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .frame(width: 220, height: 50)
                    .background(Color.green)
                    .cornerRadius(35)
                    .padding(20)
            }
            
            Spacer()
            
        }
        .padding()

    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
