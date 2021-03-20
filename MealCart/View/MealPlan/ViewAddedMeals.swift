//
//  ViewAddedMeals.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-03-19.
//

import SwiftUI

struct ViewAddedMeals: View {
    var addedRecipes: [Recipe]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(addedRecipes, id: \.self) { recipe in
                    NavigationLink(
                        destination: RecipeDetail(recipe: recipe),
                        label: {
                            AddedMealRow(recipe: recipe)
                        })
                }
            }
        }
        .navigationTitle("Review your meals")
    }
}

struct ViewAddedMeals_Previews: PreviewProvider {
    static var recipes = ModelData().recipeData.recipes
    
    static var previews: some View {
        NavigationView {
            ViewAddedMeals(addedRecipes: recipes)
        }
    }
}
