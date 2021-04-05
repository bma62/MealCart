//
//  FirestoreMealPlan.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-03.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// Each document store under Firestore/mealPlans is composed of recipe information and userID
struct FirestoreMealPlan: Identifiable, Codable {
    @DocumentID var id = UUID().uuidString // Get a uuid as document name
    var userId: String
    var isFavourite: Bool
    var recipe: Recipe
}

class FirestoreMealPlanViewModel: ObservableObject {
    @Published var mealPlan = [FirestoreMealPlan]()
    @Published var mealPlanRecipes = [Recipe]()
    
    private var db = Firestore.firestore()
    
    // MARK: Meal Plans
    
    // Fetch the logged-in user's meal plan
    func fetchMealPlan(userId: String) {

        db.collection("mealPlans")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.mealPlan = querySnapshot.documents.compactMap { document -> FirestoreMealPlan? in
                        try? document.data(as: FirestoreMealPlan.self)
                    }
                    self.mealPlanRecipes = [] 
                    self.mealPlan.forEach { (firestoreMealPlan) in
                        self.mealPlanRecipes.append(firestoreMealPlan.recipe)
                    }
                }
            }
    }
    
    // Add the user's meal plan to Firestore
    func addMealPlan(userId: String) {

        mealPlan.forEach { (userMealPlan) in
            do {
                let _ = try db.collection("mealPlans").addDocument(from: userMealPlan)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription).")
            }
        }
        
    }
    
    // Remove a user's meal plan
    func removeMealPlan(userId: String) {

        db.collection("mealPlans")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                }
            }
    }
    
    // MARK: Favourite Recipes
    // Generate meal plan for user-selected recipes
    func generateMealPlan(userId: String) {
        self.mealPlan = []
        var favouriteRecipes = [Recipe]()
        
        // Get a list of the user's favourite recipes
        let favouriteMealPlan = fetchFavouriteMealPlan(userId: userId)
        favouriteMealPlan.forEach { (favouriteMealPlan) in
            favouriteRecipes.append(favouriteMealPlan.recipe)
        }
        
        // Compare if the recipe is already favourite
        self.mealPlanRecipes.forEach { (recipe) in
            if favouriteRecipes.contains(recipe) {
                self.mealPlan.append(FirestoreMealPlan(userId: userId, isFavourite: true, recipe: recipe))
            } else {
                self.mealPlan.append(FirestoreMealPlan(userId: userId, isFavourite: false, recipe: recipe))
            }
        }
    }
    
    func fetchFavouriteMealPlan(userId: String) -> [FirestoreMealPlan] {
        var favouriteRecipes = [FirestoreMealPlan]()
        
        db.collection("favouriteRecipes")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    favouriteRecipes = querySnapshot.documents.compactMap { document -> FirestoreMealPlan? in
                        try? document.data(as: FirestoreMealPlan.self)
                    }
                }
            }
        return favouriteRecipes
    }
}
