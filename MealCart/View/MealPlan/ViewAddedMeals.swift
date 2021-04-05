//
//  ViewAddedMeals.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-03-19.
//

import SwiftUI

struct ViewAddedMeals: View {
    @Binding var addedRecipes: [Recipe]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(addedRecipes, id: \.self) { recipe in
                        NavigationLink(
                            destination: RecipeDetail(recipe: recipe, showFavouriteButton: false, isFavourite: .constant(false)),
                            label: {
                                AddedMealRow(recipe: recipe)
                            })
                    }
                    .onDelete(perform: { indexSet in
                        addedRecipes.remove(atOffsets: indexSet)
                    })
                }
            }
            .navigationTitle("Review your meals")
            
            .toolbar {
                EditButton()
            }
        }
    }
}

struct ViewAddedMeals_Previews: PreviewProvider {
    @State static var recipes = ModelData().recipeData.recipes
    
    static var previews: some View {
        NavigationView {
            ViewAddedMeals(addedRecipes: $recipes)
        }
    }
}
