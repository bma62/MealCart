//
//  FavouritesView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-05.
//

/*
 The view to let the user browse saved favourite recipes
 */
import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var mealPlanViewModel: FirestoreMealPlanViewModel
    
    var body: some View {
        NavigationView {
            if mealPlanViewModel.favouriteMealPlan.isEmpty {
                Text("No Favourite Recipes")
            } else {
                List{
                    // One row for each favourite meal
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
                        // The published array will be automatically updated because of a snapshot listener was established 
                        //                        mealPlanViewModel.favouriteMealPlan.remove(atOffsets: indexSet)
                    })
                }
                .navigationTitle("Favourite Recipes")
                .toolbar {
                    EditButton()
                }
            }
        }
        .onAppear() {
            // Fetch on every appearance in case new meals are marked as favourites in other views
            mealPlanViewModel.fetchFavouriteMealPlan(userId: session.profile!.uid)
        }
    }
}
