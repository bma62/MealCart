//
//  MealPlanHome.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-06.
//

import SwiftUI

struct MealPlanHome: View {
    var recipes: [Recipe]
    
    let layout = [
        GridItem(.flexible(minimum: 50, maximum: 200), spacing: 16, alignment: .top),
        GridItem(.flexible(minimum: 50, maximum: 200))
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 16) {
                    ForEach(recipes, id: \.self) { recipe in
                        NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                            MealPlanItem(recipe: recipe)
                        }
                    }
                }
                .padding(.horizontal, 12)
            }.navigationTitle("Meal Plan")
        }
    }
}

struct MealPlanHome_Previews: PreviewProvider {
    static var recipes = ModelData().recipeData.recipes
    
    static var previews: some View {
        MealPlanHome(recipes: Array(recipes.prefix(5)))
    }
}
