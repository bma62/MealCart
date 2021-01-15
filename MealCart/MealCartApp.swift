//
//  MealCartApp.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-05.
//

import SwiftUI

@main
struct MealCartApp: App {
    
    @StateObject private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            RecipeDetail(recipe: modelData.recipes[0])
                .environmentObject(modelData)
        }
    }
}
