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

// Structure of response when getting random recipes
struct RecipeData: Hashable, Codable {
    var recipes: [Recipe]
}

// Structure of response when searching recipes
struct SearchRecipes: Hashable, Codable {
    var results: [Recipe]
}

struct Recipe: Hashable, Codable, Identifiable {
    //conform to codable to encode/decode with external representations such as JSON, identifiable to be used in lists
    
    // MARK: Properties
    
    var id: Int
    var title: String
//    var servings: Int
    var readyInMinutes: Int?
    
    // Note: after inspecting more API recipes, it seems some have empty instructions
    var analyzedInstructions: [AnalyzedInstructions]?
    
    struct AnalyzedInstructions: Codable, Hashable {
        var steps: [InstructionStep]
        
        struct InstructionStep: Codable, Hashable {
            var number: Int
            var step: String
        }
    }
    
    var extendedIngredients: [Ingredient]?
    
    struct Ingredient: Codable, Hashable, Identifiable {
        var id: Int?
        var aisle: String?
        var name: String
        var originalString: String
        var unit: String
        var amount: Double
    }
    
    // make image URL private because users of the struct care about the image only
    private var image: String?
    var recipeImage: RemoteImage {
        
        if let image = image {
            // If an url is provided, load the remote image from URL
            return RemoteImage(url: image)
        }
        else {
            // If image url is nil, display a default no image available picture
            return RemoteImage(url: "https://upload.wikimedia.org/wikipedia/commons/a/ac/No_image_available.svg")
        }
    }
}

// MARK: API Integration
class SpoonacularAPI {
    
    // Get 6 random recipes from the API
    func getRandomRecipes(completion: @escaping ([Recipe]) -> Void) {
        
        // MARK: RapidAPI version
        //        guard let url = URL(string: "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/random") else {
        //            fatalError("Error creating URL object")
        //        }
        //
        //        // URL request
        //        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        //
        //        // required headers for RapidAPI
        //        let headers = [
        //            "x-rapidapi-key": "76b131f22bmsh9bc25358f01fd32p1ea0b6jsna39871c1bc90",
        //            "x-rapidapi-host": "spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
        //        ]
        //
        //        request.allHTTPHeaderFields = headers
        //
        //        request.httpMethod = "GET"
        //
        //        URLSession.shared.dataTask(with: request) { data, response, error in
        //            guard let data = data, error == nil else {
        //                fatalError("Failed to load data")
        //            }
        //
        //            do {
        //                // return recipes upon completion
        //                let decoder = JSONDecoder()
        //                let decodedData = try decoder.decode(RecipeData.self, from: data)
        //
        //                DispatchQueue.main.async {
        //                    completion(decodedData.recipes)
        //                }
        //            }  catch {
        //                fatalError("Couldn't parse URL's response correctly")
        //            }
        //        }
        //        .resume()
        
        // MARK: Spoonacular version
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spoonacular.com"
        components.path = "/recipes/random"
        components.queryItems = [
            //            URLQueryItem(name: "apiKey", value: "a67a5241c34f45429f75c2d8a1858a67"),
            URLQueryItem(name: "apiKey", value: "35bf43d4352d4f23b0d22e5854518de2"),
            URLQueryItem(name: "number", value: "6")
        ]
        
        // Getting a URL from our components is as simple as
        // accessing the 'url' property.
        guard let url = components.url else {
            fatalError("Error creating URL object")
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                fatalError("Failed to load data")
            }
            
            do {
                // return recipes upon completion
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(RecipeData.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData.recipes)
                }
            }  catch {
                fatalError("Couldn't parse URL's response correctly")
                //                print(error)
            }
        }
        .resume()
    }
    
    // Send a query with keyword to search recipes
    func searchRecipes(query: String, completion: @escaping ([Recipe]) -> Void) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spoonacular.com"
        components.path = "/recipes/complexSearch"
        components.queryItems = [
            //            URLQueryItem(name: "apiKey", value: "a67a5241c34f45429f75c2d8a1858a67"),
            URLQueryItem(name: "apiKey", value: "35bf43d4352d4f23b0d22e5854518de2"),
            URLQueryItem(name: "number", value: "6"),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "instructionsRequired", value: "true"),  // Include only recipes with instructions
            URLQueryItem(name: "fillIngredients", value: "true"),       // Get ingredients as well
            URLQueryItem(name: "addRecipeInformation", value: "true")  // Get instructions too
        ]
        
        // Getting a URL from our components is as simple as
        // accessing the 'url' property.
        guard let url = components.url else {
            fatalError("Error creating URL object")
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                fatalError("Failed to load data")
            }
            
            do {
                // return recipes upon completion
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(SearchRecipes.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData.results)
                }
            }  catch {
                fatalError("Couldn't parse URL's response correctly")
                //                print(error)
            }
        }
        .resume()
    }
    
    func extractRecipeFromWebsite(url: String, completion: @escaping (Recipe?, Error?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.spoonacular.com"
        components.path = "/recipes/extract"
        components.queryItems = [
            //            URLQueryItem(name: "apiKey", value: "a67a5241c34f45429f75c2d8a1858a67"),
            URLQueryItem(name: "apiKey", value: "35bf43d4352d4f23b0d22e5854518de2"),
            URLQueryItem(name: "url", value: url),  // URL of the recipe
            URLQueryItem(name: "forceExtraction", value: "true"),
            URLQueryItem(name: "analyze", value: "true")
        ]
        
        // Getting a URL from our components is as simple as
        // accessing the 'url' property.
        guard let url = components.url else {
            fatalError("Error creating URL object")
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                fatalError("Failed to load data")
            }
            
            do {
                // return recipe upon completion
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Recipe.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData, nil) // Extraction successful with no error
                }
            }  catch {
                
                print(error)
                completion(nil, error)
            }
        }
        .resume()
    }
}
