//
//  FavouritesView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-05.
//

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var mealPlanViewModel: FirestoreMealPlanViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                List{
                    ForEach(mealPlanViewModel.favouriteMealPlan, id: \.self) { mealPlan in
                        NavigationLink(
                            destination: RecipeDetail(recipe: mealPlan.recipe, showFavouriteButton: false, isFavourite: .constant(false)),
                            label: {
                                AddedMealRow(recipe: mealPlan.recipe)
                            })
                    }
                }
            }
            .navigationTitle("Favourite Recipes")
        }
        .onAppear() {
            mealPlanViewModel.fetchFavouriteMealPlan(userId: session.profile!.uid)
        }
    }
}
