//
//  NameField.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-08.
//

// A subview for first and last names used in the signup view
import SwiftUI

struct NameField: View {
    @Binding var name: String
    var displayString: String
    var backgroundColour: Color
    
    var body: some View {
        TextField(displayString, text: $name)
            .textContentType(.name)
            .autocapitalization(.words)
            .disableAutocorrection(true)
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).strokeBorder())
            .background(backgroundColour)
            .cornerRadius(25)
            .padding(.bottom, 20)
    }
}

struct NameField_Previews: PreviewProvider {
    @State static var firstName = ""
    
    static var previews: some View {
        NameField(name: $firstName, displayString: "First Name", backgroundColour: Color.gray)
    }
}
