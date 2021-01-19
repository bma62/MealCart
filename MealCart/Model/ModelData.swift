//
//  ModelData.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-14.
//

/*
 This class decodes the recipeData.json file and save the data into recipeData, use this for development purposes
*/

import Foundation
import Combine

//final prevents the class from being inherited or overridden
//SwiftUI subscribes to ObservableObject and updates any views that depend on this data
final class ModelData: ObservableObject {
    // publish any changes of the recipe data so views can update themselves
    @Published var recipeData:RecipeData = load("recipeData.json")
}

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    // get the file URL
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle")
    }

    // read from the file
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("couldn't load \(filename) from main bundle:\n\(error)")
    }

    // decode the JSON file
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
