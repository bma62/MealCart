//
//  MealCartApp.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-05.
//

import SwiftUI

@main
struct MealCartApp: App {
    // use StateObject to initialize a model object only once during the life time of the app
    /*
     on contrast, ObservedObject is used only if that object is discarded after each use
     */
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            RecipeDetail(recipe: modelData.recipeData.recipes[0])
                .environmentObject(modelData)
        }
    }
}
