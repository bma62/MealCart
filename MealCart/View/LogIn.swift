//
//  LogIn.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-26.
//

import SwiftUI

struct LogIn: View {
    
    let lightGrey = Color(red: 239/255, green: 243/255, blue: 244/255)
    
    @State var email: String = ""
    @State var password: String = ""
    
    
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
                    .cornerRadius(5.0)
                    .background(lightGrey)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $password)
                    .padding()
                    .cornerRadius(5.0)
                    .background(lightGrey)
                    .padding(.bottom, 20)
                
                

            }
            .padding()
        }
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn()
    }
}
