//
//  AddressField.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-08.
//

// A subview for address used in the signup view
import SwiftUI

struct AddressField: View {
    @Binding var address: String
    var backgroundColour: Color
    
    var body: some View {
        TextField("Address", text: $address)
            .textContentType(.streetAddressLine1)
            .autocapitalization(.words)
            .disableAutocorrection(true)
            .padding()
            .background(RoundedRectangle(cornerRadius: 25).strokeBorder())
            .background(backgroundColour)
            .cornerRadius(25)
            .padding(.bottom, 20)
    }
}

struct AddressField_Previews: PreviewProvider {
    @State static var address = ""
    
    static var previews: some View {
        AddressField(address: $address, backgroundColour: Color.gray)
    }
}
