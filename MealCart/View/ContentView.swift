//
//  ContentView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-05.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    var recipe: Recipe
    
    var body: some View {
        RecipeDetail(recipe:recipe)
    }
}

struct ContentView_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            ContentView(recipe: modelData.recipeData.recipes[0])
                .environmentObject(modelData)
        }
    }
}
