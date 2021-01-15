//
//  Recipe.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-14.
//

import Foundation
import SwiftUI

struct Recipe: Hashable, Codable, Identifiable {
    //conform to codable to encode/decode with external representations such as JSON, identifiable to be used in lists
    
    var id: Int
    var title: String
    var servings: Int
    var readyInMinutes: Int
    var instructions: String
    var extendedIngredients: [Ingredient]
    
    struct Ingredient: Codable, Hashable {
        var aisle: String
        var name: String
        var amount: Double
        var unit: String //eg: cup
        var unitLong: String //eg: cups
        var originalStrng: String //eg: 2 cups of sliced almonds
    }
    
    // make image URL private because users of the struct care about the image only
    private var image: String
    var recipeImage: RemoteImage {
        RemoteImage(url: image)
    }
    
    
}
