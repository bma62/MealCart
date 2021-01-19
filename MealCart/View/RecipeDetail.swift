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
    
    var recipeIndex: Int {
        // this provides an optional but we know there will be exactly one match, so force it to unwrap
        // compute the index of the input recipe by comparing with model data
        modelData.recipeData.recipes.firstIndex(where: { $0.id == recipe.id })!
    }
    
    @State private var displayMode = "ingredients"
    
    var body: some View {
        VStack {
            recipe.recipeImage
//                .ignoresSafeArea(edges: .top)
                .aspectRatio(contentMode: .fill)
                .frame(height: 300)
            
            HStack {
                Text(recipe.title)
                    .font(.title)
                    .padding(.leading)
                // the favourite property hasn't been connected to data model yet
                FavouriteButton(isSet: .constant(true))
            }
            
            Divider()
                .offset(y: -5)
            
            Picker("Menu", selection: $displayMode) {
                Text("Ingredients").tag("ingredients")
                Text("Instructions").tag("instructions")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            if displayMode == "ingredients" {
                List {
                    ForEach(recipe.extendedIngredients) { ingredient in
                        // display each ingredient and get rid of decimal points
                        Text("\(Int(ingredient.amount)) \(ingredient.unit) \(ingredient.name)")
                    }
                }
                // set edge insets to 0 so content extends to the edges of the display
                .listRowInsets(EdgeInsets())

            } else {
                // TODO: this should be changed to analyzed instructions
                List {
                    Text(recipe.instructions)
                }
                .listRowInsets(EdgeInsets())
            }
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
        .listStyle(InsetListStyle())
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        NavigationView {
            RecipeDetail(recipe: modelData.recipeData.recipes[0])
                .environmentObject(modelData)
        }
    }
}
