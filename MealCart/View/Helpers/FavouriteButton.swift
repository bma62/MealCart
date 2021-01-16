//
//  FavouriteButton.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-16.
//

import SwiftUI

struct FavouriteButton: View {
    
    // use binding to read-write to the data source
    @Binding var isSet: Bool
    
    var body: some View {
        Button(action: {
            isSet.toggle()
        }) {
            Image(systemName: isSet ? "heart.fill" : "heart")
                .foregroundColor(.pink)
        }
    }
}

struct FavouriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteButton(isSet: .constant(true))
    }
}
