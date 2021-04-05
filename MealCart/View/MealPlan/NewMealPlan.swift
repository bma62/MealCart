//
//  NewMealPlan.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-08.
//

import SwiftUI

struct NewMealPlan: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mealPlanViewModel: FirestoreMealPlanViewModel
    @EnvironmentObject var session: SessionStore
    
    @State var apiRecipes: [Recipe] = [] // New recipes to show on the page
    @State var addedRecipes: [Recipe] = [] //Recipes the user decides to add
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: Constants.viewLayout.twoColumnGrid, spacing: 16) {
                        ForEach(apiRecipes) { recipe in
                            
                            NavigationLink(destination: RecipeDetail(recipe: recipe, showFavouriteButton: false, isFavourite: .constant(false))) {
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
                
                HStack {
                    Button(action: {
                        SpoonacularAPI().getRandomRecipes { (recipes) in
                            apiRecipes = recipes
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.largeTitle)
                            .padding(.all)
                    }
                    Spacer()
                    
                    NavigationLink(destination: ViewAddedMeals(addedRecipes: $addedRecipes), label: {
                        Image(systemName: "cart.fill")
                            .font(.largeTitle)
                            .overlay(BadgeNumberLabel(addedRecipes: $addedRecipes), alignment: .topTrailing)
                            .padding(.all)
                    })
                }
                
                Button(action: {
                    // Pass added recipes back to home page
                    mealPlanViewModel.mealPlanRecipes = addedRecipes
                    mealPlanViewModel.generateMealPlan(userId: session.profile!.uid) //TODO: test favourites
                    mealPlanViewModel.removeMealPlan(userId: session.profile!.uid)
                    mealPlanViewModel.addMealPlan(recipes: addedRecipes, userId: session.profile!.uid)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Finish")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add Meals")
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                })
                
            }
        }
        // Query API and get some randome recipes
        .onAppear {
            SpoonacularAPI().getRandomRecipes { (recipes) in
                apiRecipes = recipes
            }
        }
    }
}

// MARK: A badge to show number of added meals on shopping cart 
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

struct NewMealPlan_Previews: PreviewProvider {

    static let mealPlanViewModel = FirestoreMealPlanViewModel()
    
    static var previews: some View {
        NavigationView {
            NewMealPlan()
                .environmentObject(mealPlanViewModel)
        }
    }
}


