//
//  MealPlanHome.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-06.
//

// The homepage consisting of the user's current meal plans
import SwiftUI

struct MealPlanHome: View {
    
    let layout = Constants.viewLayout.twoColumnGrid;
    
    @EnvironmentObject var mealPlanViewModel : FirestoreMealPlanViewModel
    @State private var showingNewMealPlan = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 16) {
                        ForEach(mealPlanViewModel.mealPlan) { userMealPlan in
                            
                            // Compute the index of this meal plan in view model
                            let mealPlanIndex = mealPlanViewModel.mealPlan.firstIndex(where: { $0.id == userMealPlan.id })!
                            NavigationLink(
                                destination: RecipeDetail(recipe: userMealPlan.recipe, showFavouriteButton: true, isFavourite: $mealPlanViewModel.mealPlan[mealPlanIndex].isFavourite, documentId: userMealPlan.id!),
                                label: {
                                    MealPlanItem(recipe: userMealPlan.recipe)
                                })
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                // Start new meal plan button 
                NavigationLink(
                    destination: NewMealPlan(isActive: $showingNewMealPlan),
                    isActive: self.$showingNewMealPlan,
                    label: {
                        Button(action: { showingNewMealPlan.toggle() }) {
                            Text("Start New Meal Plan")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 220, height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .padding(.bottom)
                    })
            }
            .navigationTitle("Meal Plan")
            //            .fullScreenCover(isPresented: $showingNewMealPlan) {
            //                NewMealPlan()
            //            }
        }
        .onAppear(){
            print("HOME APPEARED")
        }
    }
}

struct MealPlanHome_Previews: PreviewProvider {
    
    static let mealPlanViewModel = FirestoreMealPlanViewModel()
    
    static var previews: some View {
        MealPlanHome()
            .environmentObject(mealPlanViewModel)
    }
}
