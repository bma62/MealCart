//
//  FirestoreMealPlan.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-03.
//

/*
 Struct and function to work with Firestore
 */

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// Document of the user's meal plan
struct FirestoreMealPlan: Identifiable, Hashable, Codable {
    @DocumentID var id = UUID().uuidString // Get a uuid as document name
    var userId: String
    var isFavourite: Bool
    var recipe: Recipe
    @ServerTimestamp var createdTime: Timestamp? // Let Firestore write server time to each document for ordering
}

// Document to store items in the user's Shopping List
struct FirestoreShoppingListItem: Identifiable, Hashable, Codable {
    @DocumentID var id = UUID().uuidString
    var userId: String
    var name: String
    var unit: String
    var amount: Double
    @ServerTimestamp var createdTime: Timestamp? // Let Firestore write server time to each document for ordering
}

class FirestoreMealPlanViewModel: ObservableObject {
    @Published var mealPlan = [FirestoreMealPlan]() // The user's current meal plans
    @Published var mealPlanRecipes = [Recipe]() // Recipes the user added in NewMealPlan page
    @Published var favouriteMealPlan = [FirestoreMealPlan]() // The user's favourite meal plans
    @Published var shoppingList = [FirestoreShoppingListItem]() // The user's current shopping list
    
    private var db = Firestore.firestore()
    
    // MARK: Meal Plans
    
    // Fetch the logged-in user's current meal plan
    func fetchMealPlan(userId: String) {
        
        db.collection("mealPlans")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdTime")
            // Subscribe to updates at the server side
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.mealPlan = querySnapshot.documents.compactMap { document -> FirestoreMealPlan? in
                        try? document.data(as: FirestoreMealPlan.self)
                    }
                }
            }
    }
    
    // Update a user's meal plan with newly added recipes
    func updateMealPlan(userId: String) {
        
        // First, remove current meal plans from the db
        db.collection("mealPlans")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    fatalError("Error getting documents: \(err.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    
                    // Generate meal plans to store in Firestore with added recipes
                    self.generateMealPlan(userId: userId)
                }
            }
    }
    
    // Generate meal plan from user-selected recipes
    func generateMealPlan(userId: String) {
        self.mealPlan = [] // Clear current local meal plans
        var favouriteRecipes = [Recipe]()
        
        // Retrieve a list of the user's favourite recipes
        fetchFavouriteMealPlan(userId: userId)
        favouriteMealPlan.forEach { (favMealPlan) in
            favouriteRecipes.append(favMealPlan.recipe)
        }
        
        // Compare if the recipe is already favourite
        self.mealPlanRecipes.forEach { (recipe) in
            if favouriteRecipes.contains(recipe) {
                self.mealPlan.append(FirestoreMealPlan(userId: userId, isFavourite: true, recipe: recipe)) // Initialize the isFavourite field to true
            } else {
                self.mealPlan.append(FirestoreMealPlan(userId: userId, isFavourite: false, recipe: recipe)) // Initialize the isFavourite field to true
            }
        }
        
        // After meal plans are generated, push them onto the db
        self.addMealPlan(userId: userId)
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
        
        // Updates are done, clear local recipes the user selected
        mealPlanRecipes = []
        
        removeShoppingList(userId: userId, shouldRegenerateList: true)
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
        
        // Retrieve the specific meal plan after it's been updated
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
                        .whereField("recipe.id", isEqualTo: userMealPlan!.recipe.id) // Find the meal plan with that recipe
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
    
    // A function to add the user's own recipe to the current meal plan
    func addRecipeToMealPlan(recipe: Recipe, userId: String) {
        let newMealPlan = FirestoreMealPlan(userId: userId, isFavourite: false, recipe: recipe)
        
        do {
            let _ = try db.collection("mealPlans").addDocument(from: newMealPlan)
        }
        catch {
            fatalError("Unable to encode task: \(error.localizedDescription).")
        }
    }
    
    // MARK: Favourite Recipes
    
    // A function to fetch the logged-in user's favourite recipes
    func fetchFavouriteMealPlan(userId: String) {
        
        db.collection("favouriteRecipes")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdTime") // Order by time pushed onto the server to maintain the order of when user added them
            // Subscribe to server-side updates
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.favouriteMealPlan = querySnapshot.documents.compactMap { document -> FirestoreMealPlan? in
                        try? document.data(as: FirestoreMealPlan.self)
                    }
                }
            }
    }
    
    // A function to push local changes to favourite meal plans to Firestore
    func removeFavouriteMealPlan(favouriteMealPlan: FirestoreMealPlan) {
        
        // If the removed favourite meal plan is in the user's currently meal plan, that meal plan's isFavourite field and DB records need to be updated too
        if let currentMealPlan = mealPlan.first(where: {$0.recipe == favouriteMealPlan.recipe}) {
            updateMealPlanIsFavourite(documentId: currentMealPlan.id!, isFavourite: false)
        } else {
            db.collection("favouriteRecipes").document(favouriteMealPlan.id!).delete() { err in
                if let err = err {
                    fatalError("Error removing document: \(err)")
                } else {
                    print("Document removed")
                }
            }
        }
    }
    
    // MARK: Shopping Lists
    
    func fetchShoppingList(userId: String) {
        
        db.collection("shoppingLists")
            .whereField("userId", isEqualTo: userId)
            .order(by: "createdTime")
            // Subscribe to updates at the server side
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.shoppingList = querySnapshot.documents.compactMap { document -> FirestoreShoppingListItem? in
                        try? document.data(as: FirestoreShoppingListItem.self)
                    }
                }
            }
    }
    
    // Remove the user's current shopping list to prepare for new upload
    func removeShoppingList(userId: String, shouldRegenerateList: Bool) {
        
        db.collection("shoppingLists")
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    fatalError("Error getting documents: \(err.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        document.reference.delete()
                    }
                    if shouldRegenerateList {
                        self.generateShoppingList(userId: userId)

                    }
                }
            }
    }
    
    // Generate a new shopping list for current meal plans
    func generateShoppingList(userId: String) {
        
        shoppingList = [] // Clear previous records
        
        mealPlan.forEach { (userMealPlan) in
            // Test if the ingredients are not nil
            if let ingredients = userMealPlan.recipe.extendedIngredients {
                ingredients.forEach({ (ingredient) in
                    // Test if this ingredient name and unit is already in array
                    if let index = shoppingList.firstIndex(where: {$0.name == ingredient.name && $0.unit == ingredient.unit}) {
                        shoppingList[index].amount += ingredient.amount
                    } else {
                        // Otherwise, append this new ingredient
                        shoppingList.append(FirestoreShoppingListItem(userId: userId, name: ingredient.name, unit: ingredient.unit, amount: ingredient.amount))
                    }
                })
            }
        }
        
        addShoppingList(userId: userId)
    }
    
    // Push local shopping list to Firestore
    func addShoppingList(userId: String) {
        
        shoppingList.forEach { (shoppingListItem) in
            do {
                let _ = try db.collection("shoppingLists").addDocument(from: shoppingListItem)
            }
            catch {
                fatalError("Unable to encode task: \(error.localizedDescription).")
            }
        }
    }
    
    func removeShoppingListItem(userId: String, at index: Int) {
        let documentId = shoppingList[index].id!
        
        db.collection("shoppingLists").document(documentId).delete() { err in
            if let err = err {
                fatalError("Error removing document: \(err)")
            } else {
                print("Document removed")
            }
        }    }
}
