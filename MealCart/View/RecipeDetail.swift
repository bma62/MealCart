//
//  RecipeDetail.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-14.
//

import SwiftUI

struct RecipeDetail: View {
    
    var recipe: Recipe
    
    @State private var displayMode = "ingredients"
    
    var body: some View {
        ScrollView {
            recipe.recipeImage
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
            
            HStack {
                Text(recipe.title)
                    .font(.title)
                    .padding(.leading)
                // the favourite property hasn't been connected to data model yet
                FavouriteButton(isSet: .constant(true))
            }
            
            Divider()
                .offset(y: -5)
            
            // 2 option tags for the picker to show different lists
            Picker("Menu", selection: $displayMode) {
                Text("Ingredients")
                    .tag("ingredients")
                Text("Instructions")
                    .tag("instructions")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            VStack (alignment: .leading, spacing: 15) {
                if displayMode == "ingredients" {
                    ForEach(recipe.extendedIngredients) { ingredient in
                        // display each ingredient - use original string instead of units and amounts to avoid cases like 0.3333 cup butter
                        Text(ingredient.originalString)
                        Divider()
                    }
                } else {
                    // because step is not Identifiable, use its number as id
                    ForEach(recipe.analyzedInstructions[0].steps, id: \.number) { step in
                        Text("\(step.number). \(step.step)")
                        Divider()
                    }
                }
            }
            .padding(.horizontal, 30)
            .lineLimit(nil)
            .offset(y: 5)
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        NavigationView {
            RecipeDetail(recipe: modelData.recipeData.recipes[3])
        }
    }
}
