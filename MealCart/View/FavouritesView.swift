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
    
    @State var favouriteRecipes = [FirestoreMealPlan]()
    
    var body: some View {
        VStack {
            List{
                ForEach(favouriteRecipes, id: \.self) { recipe in
                    NavigationLink(
                        destination: RecipeDetailWithFavouriteButton(userMealPlan: recipe),
                        label: {
                            AddedMealRow(recipe: recipe.recipe)
                        })
                }
            }
        }
//        .onAppear() {
//            favouriteRecipes = mealPlanViewModel.fetchFavouriteMealPlan(userId: session.profile!.uid)
//        }
    }
    
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
            .environmentObject(SessionStore())
            .environmentObject(FirestoreMealPlanViewModel())
    }
}
