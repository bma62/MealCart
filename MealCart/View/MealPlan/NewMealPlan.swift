//
//  NewMealPlan.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-08.
//

// The homepage view when the user wants to start a new meal plan and add meals
import SwiftUI

struct NewMealPlan: View {
    //    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var mealPlanViewModel: FirestoreMealPlanViewModel
    @EnvironmentObject var session: SessionStore
    @Binding var isActive: Bool // Binding to trigger going back to home screen
    
    @State var apiRecipes: [Recipe] = [] // Fetched recipes from API to show on the page
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
                    // Refresh button
                    Button(action: {
                        SpoonacularAPI().getRandomRecipes { (recipes) in
                            apiRecipes = recipes
                        }
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.title)
                            .padding(.leading)
                    }
                    
                    Spacer()
                    
                    // Cart button
                    NavigationLink(destination: ViewAddedMeals(addedRecipes: $addedRecipes), label: {
                        Image(systemName: "cart.fill")
                            .font(.title)
                            .overlay(BadgeNumberLabel(addedRecipes: $addedRecipes), alignment: .topTrailing)
                            .padding(.trailing)
                    })
                }
                
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
            
            .navigationTitle("Add Meals")
            
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button(action: {
                        isActive.toggle()
                        //                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                    })
                })
                
            }
        }
        .navigationBarHidden(true) // Hide navigation bar to move contents up and hide the navigation back button
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
            NewMealPlan(isActive: .constant(true))
                .environmentObject(mealPlanViewModel)
        }
    }
}


