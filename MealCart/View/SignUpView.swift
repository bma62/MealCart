//
//  SignUp.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-26.
//

/*
 The view with sign up form for new users
 */
import SwiftUI

struct SignUpView: View {
    
    // MARK: Properties
    
    let lightGrey = Color(red: 239/255, green: 243/255, blue: 244/255)
    
    @EnvironmentObject var session: SessionStore
    
    @State var profile: UserProfile?
    
    @State var email = ""
    @State var password = ""
    @State var error = ""
    
    // MARK: Sign Up Function
    
    func signUp() {
        session.signUp(email: email, password: password) { (profile, error) in
            // if the error is not nil, read the error message
            if let error = error {
                self.error = error.localizedDescription
            } else {
                // upon successful sign up, clear the states
                self.email = ""
                self.password = ""
                self.error = ""
                self.profile = profile
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Create Account")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
            
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(25)
                .padding(.bottom, 30)
            
            EmailField(email: $email, backgroundColour: lightGrey)
            
            PasswordField(password: $password, backgroundColour: lightGrey)
            
            if (error != "") {
                Text(error)
                    .font(.caption2)
                    .foregroundColor(.red)
                    // if the error is too long to display in one line, expand size vertically
                    .fixedSize(horizontal: false, vertical: true)
                    .offset(y: -10)
            }
            
            Button(action: signUp) {
                Text("Sign Up")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.white)
                    .frame(width: 220, height: 50)
                    .background(Color.blue)
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
