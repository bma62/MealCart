//
//  RecipeDetailWithFavouriteButton.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-04.
//

import SwiftUI

struct RecipeDetailWithFavouriteButton: View {
    @EnvironmentObject var mealPlanViewModel: FirestoreMealPlanViewModel

    var userMealPlan: FirestoreMealPlan
    
    var mealPlanIndex: Int {
        // this provides an optional but we know there will be exactly one match, so force it to unwrap
        // compute the index of the input meal plan by comparing with model data
        mealPlanViewModel.mealPlan.firstIndex(where: { $0.id == userMealPlan.id })!
    }
    
    var body: some View {
        RecipeDetail(recipe: userMealPlan.recipe, showFavouriteButton: true, isFavourite: $mealPlanViewModel.mealPlan[mealPlanIndex].isFavourite)
    }
}


