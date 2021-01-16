//
//  Recipe.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-14.
//

import Foundation
import SwiftUI

struct RecipeData: Hashable, Codable {
    var recipes: [Recipe]
}

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
        var originalString: String //eg: 2 cups of sliced almonds
        
        var measures: Measure
        
        struct Measure: Codable, Hashable {
            var metric: Metric
            
            struct Metric: Codable, Hashable {
                var amount: Double
                var unitShort: String //eg: cup
                var unitLong: String //eg: cups
            }
        }
    }
    
    // make image URL private because users of the struct care about the image only
    private var image: String
    var recipeImage: RemoteImage {
        RemoteImage(url: image)
    }
}


    func getRandomRecipes() {
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

//        // How many random recipes to get?
//        request.addValue("1", forHTTPHeaderField: "number")

        request.httpMethod = "GET"

        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else {
                fatalError("Failed to load data")
            }

            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
//            if let decodedData = try? JSONDecoder().decode(Recipe, from: data) {
//                DispatchQueue.main.async {
//
//                }
//            }

        })
        .resume()

    }
