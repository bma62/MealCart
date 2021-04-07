//
//  EmailField.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-01.
//

// A subview of email used in login and signup views
import SwiftUI

struct EmailField: View {
    @Binding var email: String
    var backgroundColour: Color
    
    var body: some View {
        TextField("Email", text: $email)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).strokeBorder())
            .background(backgroundColour)
            .cornerRadius(25)
            .padding(.bottom, 20)
    }
}

struct EmailField_Previews: PreviewProvider {
    @State static var email = ""
    
    static var previews: some View {
        EmailField(email: $email, backgroundColour: Color.gray)
    }
}
