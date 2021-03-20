//
//  NewMealPlan.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-08.
//

import SwiftUI

struct NewMealPlan: View {
    @Environment(\.presentationMode) var presentationMode

    var displayedRecipes: [Recipe] // New recipes to show on the page
    @State var addedRecipes: [Recipe] = [] //Recipes the user decides to add
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Dismiss"){
                    presentationMode.wrappedValue.dismiss()
                }
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    LazyVGrid(columns: Constants.viewLayout.twoColumnGrid, spacing: 16) {
                        ForEach(displayedRecipes, id: \.self) { recipe in
                            
                            NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                                MealPlanItem(recipe: recipe)
                                    .overlay(
                                        Button(action: {
                                            // If the recipe was added, tapping the button again will remove it
                                            if let index = addedRecipes.firstIndex(of: recipe){
                                                addedRecipes.remove(at:index)
                                            }
                                            // If not, the recipe will be added
                                            else {
                                                addedRecipes.append(recipe)
                                            }
                                        }) {
                                            Image(systemName: addedRecipes.contains(recipe) ? "checkmark.circle.fill" : "plus.circle.fill")
                                        }
                                        .scaleEffect(1.7, anchor: .topTrailing), alignment: .topTrailing)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                NavigationLink(destination: ViewAddedMeals(addedRecipes: addedRecipes), label: {
                    Spacer()
                    Image(systemName: "cart.fill")
                        .font(.largeTitle)
                        .overlay(BadgeNumberLabel(addedRecipes: $addedRecipes), alignment: .topTrailing)
                        .padding(.all)
                })
            }
        }
        
        
    }
}

struct NewMealPlan_Previews: PreviewProvider {
    static var recipes = ModelData().recipeData.recipes
    
    static var previews: some View {
        NavigationView {
            NewMealPlan(displayedRecipes: Array(recipes.prefix(5)))
        }
    }
}

struct BadgeNumberLabel: View {
    @Binding var addedRecipes: [Recipe]
    
    var body: some View {
        let badgeCount = addedRecipes.count
        
        ZStack {
            Circle()
                .foregroundColor(.red)

            Text("\(badgeCount)")
                .foregroundColor(.white)
        }
        .frame(width: 20, height: 20)
        .opacity(badgeCount == 0 ? 0 : 1.0) // Hide the badge if no recipe has been added
    }
}

