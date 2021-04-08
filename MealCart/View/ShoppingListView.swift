//
//  ShoppingListView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-07.
//

import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var mealPlanViewModel : FirestoreMealPlanViewModel
    //    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        NavigationView {
            List {
                //            ForEach(modelData.recipeData.recipes) { recipe in
                //                ForEach(recipe.extendedIngredients!) {ingredient in
                //                    Text("\(String(format: "%.2f", ingredient.amount)) \(ingredient.unit) \(ingredient.name)")
                //                }
                //            }
                ForEach(mealPlanViewModel.shoppingList) { shoppingListItem in
                    Text("\(String(format: "%.2f", shoppingListItem.amount)) \(shoppingListItem.unit) \(shoppingListItem.name)")
                }
                .onDelete(perform: { indexSet in
                    let index = indexSet[indexSet.startIndex]
                    mealPlanViewModel.removeShoppingListItem(userId: session.profile!.uid, at: index)
                })
            }
            .navigationTitle("Shopping List")
            .toolbar {
                EditButton()
            }
        }
    }
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShoppingListView()
                .environmentObject(FirestoreMealPlanViewModel())
//                .environmentObject(ModelData())
        }
    }
}
