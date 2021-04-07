//
//  MealCartApp.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-05.
//

/*
 The entry point of the app
 */

import SwiftUI
import Firebase

@main
struct MealCartApp: App {
    
    // Configure to use Firebase services
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("App is starting up. ApplicationDelegate didFinishLaunchingWithOptions.")
        
        FirebaseApp.configure()
        
        return true
    }
}
