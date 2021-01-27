//
//  MealCartApp.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-05.
//

/*
 Whatever views in the body here get to run on the Simulator or test device
 */

import SwiftUI
import Firebase

@main
struct MealCartApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // use StateObject to initialize a model object only once during the life time of the app
    // on contrast, ObservedObject is used only if that object is discarded after each use
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            RecipeDetail(recipe: modelData.recipeData.recipes[0])
                .environmentObject(modelData)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    
    print("App is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
    
    // Use Firebase library to configure APIs
    FirebaseApp.configure()
    
    return true
  }
}
