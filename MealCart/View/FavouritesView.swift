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
            List{
                ForEach(mealPlanViewModel.favouriteMealPlan, id: \.self) { mealPlan in
                    NavigationLink(
                        destination: RecipeDetail(recipe: mealPlan.recipe, showFavouriteButton: false, isFavourite: .constant(false)),
                        label: {
                            AddedMealRow(recipe: mealPlan.recipe)
                        })
                }
                .onDelete(perform: { indexSet in
                    // On delete, update the change to database as well
                    let index = indexSet[indexSet.startIndex]
                    mealPlanViewModel.removeFavouriteMealPlan(favouriteMealPlan: mealPlanViewModel.favouriteMealPlan[index])
                    mealPlanViewModel.favouriteMealPlan.remove(atOffsets: indexSet)
                })
            }
            .navigationTitle("Favourite Recipes")
            .toolbar {
                EditButton()
            }
        }
        .onAppear() {
            mealPlanViewModel.fetchFavouriteMealPlan(userId: session.profile!.uid)
        }
    }
}
