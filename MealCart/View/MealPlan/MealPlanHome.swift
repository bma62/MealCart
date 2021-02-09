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
    
    @State private var showingNewMealPlan = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 16) {
                        ForEach(recipes, id: \.self) { recipe in
                            NavigationLink(destination: RecipeDetail(recipe: recipe)) {
                                MealPlanItem(recipe: recipe)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                Button(action: { showingNewMealPlan.toggle() }) {
                    Text("Start New Meal Plan")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Meal Plan")
//            .fullScreenCover(isPresented: $showingNewMealPlan) {
//                NewMealPlan()
//            }
            .sheet(isPresented: $showingNewMealPlan) {
                NewMealPlan()
            }
        }
    }
}

struct MealPlanHome_Previews: PreviewProvider {
    static var recipes = ModelData().recipeData.recipes
    
    static var previews: some View {
        MealPlanHome(recipes: Array(recipes.prefix(5)))
    }
}
