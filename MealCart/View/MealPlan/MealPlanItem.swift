//
//  RecipeCard.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-06.
//

// A view to display a recipe's cover in meal plan card style

import SwiftUI

struct MealPlanItem: View {
    var recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            recipe.recipeImage
                .scaledToFit()
                .cornerRadius(5)
            
            Text(recipe.title)
                .foregroundColor(.primary)
                .font(.caption)
        }
    }
}

struct MealPlanItem_Previews: PreviewProvider {
    static var previews: some View {
        MealPlanItem(recipe: ModelData().recipeData.recipes[1])
    }
}
