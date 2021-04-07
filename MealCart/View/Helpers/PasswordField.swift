//
//  PasswordField.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-01.
//

// A subview of password used in login and signed
import SwiftUI

struct PasswordField: View {
    @Binding var password: String
    var backgroundColour: Color
    
    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).strokeBorder())
            .background(backgroundColour)
            .cornerRadius(25)
            .padding(.bottom, 20)
    }
}

struct PasswordField_Previews: PreviewProvider {
    @State static var password = ""
    
    static var previews: some View {
        PasswordField(password: $password, backgroundColour: Color.gray)
    }
}
