//
//  LogIn.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-26.
//

import SwiftUI

struct LogInView: View {
    
    // MARK: Properties
    
    let lightGrey = Color(red: 239/255, green: 243/255, blue: 244/255)
    
    @EnvironmentObject var session: SessionStore
    
    @State var email = ""
    @State var password = ""
    @State var error = ""
    
    // MARK: Log In Function
    
    func logIn() {
        session.logIn(email: email, password: password) { (result, error) in
            // if the error is not nil, read the error message
            if let error = error {
                self.error = error.localizedDescription
            } else {
                // upon successful log in, clear the states
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
                    .padding(.bottom, 30)
                
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25).strokeBorder())
                    .background(lightGrey)
                    .cornerRadius(25)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 25).strokeBorder())
                    .background(lightGrey)
                    .cornerRadius(25)
                    .padding(.bottom, 20)
                
                if (error != "") {
                    Text(error)
                        .font(.caption2)
                        .foregroundColor(.red)
                        // if the error is too long to display in one line, expand size vertically
                        .fixedSize(horizontal: false, vertical: true)
                        .offset(y: -10)
                }
                                
                Button(action: logIn) {
                    Text("Log In")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.white)
                        .frame(width: 220, height: 50)
                        .background(Color.green)
                        .cornerRadius(35)
                        .padding(20)
                        
                }
                
                NavigationLink(destination: SignUpView()) {
                    Text("Sign Up")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(35)
                }
                
                Spacer()
                
            }
            .padding()
        }
        // hide navigation bar to move contents up
        .navigationBarHidden(true)
    }

}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogInView()
                .environmentObject(SessionStore())
        }
        
    }
}
