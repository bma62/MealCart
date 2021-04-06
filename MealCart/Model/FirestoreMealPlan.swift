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
struct FirestoreMealPlan: Identifiable, Hashable, Codable {
    @DocumentID var id = UUID().uuidString // Get a uuid as document name
    var userId: String
    var isFavourite: Bool
    var recipe: Recipe
}

class FirestoreMealPlanViewModel: ObservableObject {
    @Published var mealPlan = [FirestoreMealPlan]()
    @Published var mealPlanRecipes = [Recipe]()
    @Published var favouriteMealPlan = [FirestoreMealPlan]()
    
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
                    fatalError("Error getting documents: \(err.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                }
            }
    }
    
    // Update a user meal plan's isFavourite field
    func updateMealPlanIsFavourite(documentId: String, isFavourite: Bool) {
        
        let mealPlanRef = db.collection("mealPlans").document(documentId)
        
        // Update field in the user's meal plan
        mealPlanRef.updateData(["isFavourite": isFavourite]) { err in
            if let err = err {
                fatalError("Error updaing document: \(err)")
            } else {
                print("Document updated")
            }
        }
        
        // Retrieve the specific meal plan
        mealPlanRef.getDocument { (document, error) in
            
            if let document = document, document.exists {
                // Decode the retrieved document
                let userMealPlan = try? document.data(as: FirestoreMealPlan.self)
                
                // If the user marked the meal plan as favourite, it should be added to favouriteRecipes collection;
                // Else, the user wants to remove this meal plan from favouriteRecipes collection
                if isFavourite {
                    do {
                        let _ = try self.db.collection("favouriteRecipes").addDocument(from: userMealPlan)
                    }
                    catch {
                        fatalError("Unable to encode task: \(error.localizedDescription).")
                    }
                } else {
                    self.db.collection("favouriteRecipes")
                        .whereField("userId", isEqualTo: userMealPlan!.userId)
                        .whereField("recipe.id", isEqualTo: userMealPlan!.recipe.id)
                        .getDocuments { (querySnapshot, err) in
                            if let err = err {
                                fatalError("Error getting documents: \(err.localizedDescription)")
                            } else {
                                for document in querySnapshot!.documents {
                                    document.reference.delete()
                                }
                            }
                        }
                }
            } else {
                fatalError("Document does not exist")
            }
        }
    }
    
    // MARK: Favourite Recipes
    
    // Generate meal plan for user-selected recipes
    func generateMealPlan(userId: String) {
        self.mealPlan = []
        var favouriteRecipes = [Recipe]()
        
        // Get a list of the user's favourite recipes
        fetchFavouriteMealPlan(userId: userId)
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
    
    // A function to fetch the logged-in user's favourite recipes
    func fetchFavouriteMealPlan(userId: String) {
        
        db.collection("favouriteRecipes")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.favouriteMealPlan = querySnapshot.documents.compactMap { document -> FirestoreMealPlan? in
                        try? document.data(as: FirestoreMealPlan.self)
                    }
                }
            }
    }
    
    // A function to update local changes to Firestore
    func removeFavouriteMealPlan(favouriteMealPlan: FirestoreMealPlan) {
        
        // If the removed favourite meal plan is in the user's currently meal plan, its field and db document need to be updated too
        if let currentMealPlan = mealPlan.first(where: {$0.recipe == favouriteMealPlan.recipe}) {
            updateMealPlanIsFavourite(documentId: currentMealPlan.id!, isFavourite: false)
        }
        
        db.collection("favouriteRecipes").document(favouriteMealPlan.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document removed")
            }
        }
    }
}
