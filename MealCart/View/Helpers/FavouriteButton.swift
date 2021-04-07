//
//  FavouriteButton.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-16.
//

// The favourite button to toggle a meal plan's isFavourite field
import SwiftUI

struct FavouriteButton: View {
    @EnvironmentObject var mealPlanViewModel: FirestoreMealPlanViewModel
    
    // Binding to read-write to the data source
    @Binding var isSet: Bool
    var documentId: String // DocumentID of the meal plan
    
    var body: some View {
        Button(action: {
            isSet.toggle()
            if (isSet) {
                mealPlanViewModel.updateMealPlanIsFavourite(documentId: documentId, isFavourite: true)
            } else {
                mealPlanViewModel.updateMealPlanIsFavourite(documentId: documentId, isFavourite: false)
            }
        }) {
            Image(systemName: isSet ? "heart.fill" : "heart")
                .foregroundColor(.pink)
        }
    }
}

struct FavouriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteButton(isSet: .constant(true), documentId: "")
    }
}
