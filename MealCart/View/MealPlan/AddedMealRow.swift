//
//  AddedMealRow.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-03-19.
//

import SwiftUI

struct AddedMealRow: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            recipe.recipeImage
                .scaledToFit()
                .frame(height: 70)
            Text(recipe.title)
            
            Spacer()
        }
    }
}

struct AddedMealRow_Previews: PreviewProvider {
    static var recipes = ModelData().recipeData.recipes
    
    static var previews: some View {
        AddedMealRow(recipe: recipes[0])
    }
}
