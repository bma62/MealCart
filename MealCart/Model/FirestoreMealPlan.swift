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
    var recipe: Recipe
    var userId: String
}

class FirestoreMealPlanViewModel: ObservableObject {
    @Published var mealPlan = [FirestoreMealPlan]()
    
    private var db = Firestore.firestore()
    private var userId = SessionStore().profile?.uid ?? "Test User ID"
    
    // Fetch the logged-in user's meal plan
    func fetchData() {
        
        db.collection("mealPlans")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                self.mealPlan = documents.compactMap { queryDocumentSnapshot -> FirestoreMealPlan? in
                    return try? queryDocumentSnapshot.data(as: FirestoreMealPlan.self)
                }
            }
    }
    
    // Add the user's meal plan to Firestore
    func addMealPlan(recipes: [Recipe]) {

        recipes.forEach { (recipe) in
            let userMealPlan = FirestoreMealPlan(recipe: recipe, userId: userId)
            do {
                let _ = try db.collection("mealPlans").addDocument(from: userMealPlan)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription).")
            }
        }
        
    }
    
    // Remove a user's meal plan
    func removeTask() {
        
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
}
