//
//  MealPlanHome.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-06.
//

import SwiftUI

struct MealPlanHome: View {

    #warning("TEST FOR FIRESTORE")
    @EnvironmentObject var mealPlanViewModel : FirestoreMealPlanViewModel

    let layout = Constants.viewLayout.twoColumnGrid;
    
    @State private var showingNewMealPlan = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: layout, spacing: 16) {
                        ForEach(mealPlanViewModel.mealPlanRecipes) { recipe in
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
                .padding(.bottom)
            }
            .navigationTitle("Meal Plan")
            .fullScreenCover(isPresented: $showingNewMealPlan) {
                NewMealPlan()
            }
        }
        .onAppear() {
//            mealPlanViewModel.fetchData()
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
