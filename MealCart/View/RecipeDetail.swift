//
//  RecipeDetail.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-14.
//

import SwiftUI

struct RecipeDetail: View {
    @EnvironmentObject var modelData: ModelData
    var recipe: Recipe
   
    var body: some View {
        Text("hello world")
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        RecipeDetail(recipe: modelData.recipeData.recipes[0])
            .environmentObject(modelData)
    }
}
