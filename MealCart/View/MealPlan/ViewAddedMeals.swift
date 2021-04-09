//
//  ViewAddedMeals.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-03-19.
//

// The view the user sees when tapping the cart button on NewMealPlan page
import SwiftUI

struct ViewAddedMeals: View {
    @EnvironmentObject var mealPlanViewModel: FirestoreMealPlanViewModel
    @EnvironmentObject var session: SessionStore
    @Binding var isActive: Bool // Binding to trigger going back to home screen
    
    // Binding to recipes the user added in NewMealPlan page
    @Binding var addedRecipes: [Recipe]
    
    var body: some View {
        NavigationView {
            // One row for each recipe with tapping navigation to the recipe details
            VStack {
                List {
                    ForEach(addedRecipes) { recipe in
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
                .listStyle(PlainListStyle())
                
                // Finish button
                Button(action: {
                    // Pass added recipes back to the view model to perform updates
                    mealPlanViewModel.mealPlanRecipes = addedRecipes
                    mealPlanViewModel.updateMealPlan(userId: session.profile!.uid)
                    //                    presentationMode.wrappedValue.dismiss()
                    isActive.toggle()
                }) {
                    Text("Finish")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.bottom)
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
    @State static var isActive = false
    
    static var previews: some View {
        NavigationView {
            ViewAddedMeals(isActive: $isActive, addedRecipes: $recipes)
        }
    }
}
