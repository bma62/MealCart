//
//  RecipeDetailWithFavouriteButton.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-04.
//

import SwiftUI

struct RecipeDetailWithFavouriteButton: View {
    
    var recipe: Recipe
    @Binding var isFavourite: Bool
    
    var body: some View {
        RecipeDetail(recipe: recipe, showFavouriteButton: true, isFavourite: $isFavourite)
    }
}

struct RecipeDetailWithFavouriteButton_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        RecipeDetailWithFavouriteButton(recipe: modelData.recipeData.recipes[0], isFavourite: .constant(true))
    }
}
