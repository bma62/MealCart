//
//  NewMealPlan.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-08.
//

import SwiftUI

struct NewMealPlan: View {
    @Environment(\.presentationMode) var presentationMode

    var displayedRecipes: [Recipe] // New recipes to show on the page
    var addedRecipes: [Recipe] = [] //Recipes the user decides to add
    @State var isAdded = false
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Dismiss"){
                    presentationMode.wrappedValue.dismiss()
                }
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    LazyVGrid(columns: Constants.viewLayout.twoColumnGrid, spacing: 16) {
                        ForEach(displayedRecipes, id: \.self) { recipe in
                            NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                                MealPlanItem(recipe: recipe)
                                    .overlay(AddMealButton(isAdded: $isAdded), alignment: .topTrailing)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
        
        
    }
}

struct NewMealPlan_Previews: PreviewProvider {
    static var recipes = ModelData().recipeData.recipes
    
    static var previews: some View {
        NewMealPlan(displayedRecipes: Array(recipes.prefix(5)))
    }
}

struct AddMealButton: View {
    // use binding to read-write to the data source
    @Binding var isAdded: Bool
    
    var body: some View {
        Button(action: {
            isAdded.toggle()
        }) {
            Image(systemName: isAdded ? "checkmark.circle.fill" : "plus.circle.fill")
//                .foregroundColor(.gray)
        }
        .scaleEffect(1.7, anchor: .topTrailing)

    }
    
}
