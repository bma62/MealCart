//
//  Recipe.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-14.
//

/*
 The structs in this file are used to match the JSON format of the recipe data from Spoonacular API
 */

import Foundation
import SwiftUI

struct RecipeData: Hashable, Codable {
    var recipes: [Recipe]
}

struct Recipe: Hashable, Codable, Identifiable {
    //conform to codable to encode/decode with external representations such as JSON, identifiable to be used in lists
    
    // MARK: Properties
    
    var id: Int
    var title: String
    var servings: Int
    var readyInMinutes: Int

    // Note: after inspecting more API recipes, it seems some have empty instructions
    var analyzedInstructions: [AnalyzedInstructions]
    
    struct AnalyzedInstructions: Codable, Hashable {
        var steps: [InstructionStep]
        
        struct InstructionStep: Codable, Hashable {
            var number: Int
            var step: String
        }
    }
    
    var extendedIngredients: [Ingredient]
    
    // this is not part of the API response, but we need this to distinguish the user's favourite recipes
    var isFavourite: Bool {
        false
    }
    
    struct Ingredient: Codable, Hashable, Identifiable {
        var id: Int
        var aisle: String
        var name: String
        var originalString: String
        var unit: String
        var amount: Double
    }
    
    // make image URL private because users of the struct care about the image only
    private var image: String
    var recipeImage: RemoteImage {
        // load the remote image from URL
        RemoteImage(url: image)
    }
}

// MARK: API Integration
/*
 THIS HASN'T BEEN TESTED, USE ModelData FOR NOW
 */
// because data task is async, return upon completion
func getRandomRecipes(completion: @escaping ([Recipe], Error?) -> Void) {
    
    guard let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/random") else {
        fatalError("Error creating URL object")
    }

    // URL request
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)

    // required headers for RapidAPI
    let headers = [
        "x-rapidapi-key": "76b131f22bmsh9bc25358f01fd32p1ea0b6jsna39871c1bc90",
        "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
    ]

    request.allHTTPHeaderFields = headers

    request.httpMethod = "GET"

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            fatalError("Failed to load data")
        }

        do {
            // return recipes upon completion
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(RecipeData.self, from: data)
            completion(decodedData.recipes, nil)
        }  catch {
            fatalError("Couldn't parse URL's response correctly")
        }
    }.resume()
    
}
