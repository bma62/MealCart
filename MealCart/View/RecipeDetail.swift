//
//  RecipeDetail.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-14.
//

import SwiftUI

struct RecipeDetail: View {
    
    var recipe: Recipe
    var showFavouriteButton: Bool
    @Binding var isFavourite: Bool
    var documentId: String = ""
    
    @State private var displayMode = "ingredients"
    
    var body: some View {
        ScrollView {
            recipe.recipeImage
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .scaledToFit()
            
            HStack {
                Text(recipe.title)
                    .font(.title)
                if (showFavouriteButton) {
                    FavouriteButton(isSet: $isFavourite, documentId: documentId)
                }
            }
            
            Divider()
                .offset(y: -5)
            
            // 2 option tags for the picker to show different lists
            Picker("Menu", selection: $displayMode) {
                Text("Ingredients")
                    .tag("ingredients")
                Text("Instructions")
                    .tag("instructions")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            VStack (alignment: .leading, spacing: 15) {
                
                if displayMode == "ingredients" {
                    if let ingredients = recipe.extendedIngredients {
                        ForEach(ingredients) { ingredient in
                            // display each ingredient - use original string instead of units and amounts to avoid cases like 0.3333 cup butter
                            Text(ingredient.originalString)
                            Divider()
                        }
                    } else {
                        Text("Ingredients Not Available")
                    }
                    
                } else {
                    if let instructions = recipe.analyzedInstructions {
                        // add a test in case instructions array is empty
                        if !instructions.isEmpty {
                            // because step is not Identifiable, use its number as id
                            ForEach(instructions[0].steps, id: \.number) { step in
                                Text("\(step.number). \(step.step)")
                                Divider()
                            }
                        } else {
                            Text("Instruction Not Available")
                        }
                    } else {
                        Text("Instruction Not Available")
                    }
                    
                }
            }
            .padding(.horizontal)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true) // added this to fix when text is too long, it turns into ... at the end
            .offset(y: 5)
        }
        .navigationTitle(recipe.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RecipeDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        NavigationView {
            RecipeDetail(recipe: modelData.recipeData.recipes[1], showFavouriteButton: true, isFavourite: .constant(false))
        }
    }
}
