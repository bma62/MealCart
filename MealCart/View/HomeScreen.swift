//
//  ContentView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-05.
//

import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var modelData: ModelData
//    var recipe: Recipe
    
    enum Tab {
        case mealPan
        case shoppingList
        case favourites
        case settings
    }
    
    var body: some View {
        TabView(selection: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Selection@*/.constant(1)/*@END_MENU_TOKEN@*/) {
            Text("Meal Plan Page")
                .tabItem {
                    Label("Meal Plan", systemImage: "calendar")
                }
                .tag(Tab.mealPan)
            
            Text("Shopping List Page")
                .tabItem {
                    Label("Shopping List", systemImage: "list.bullet")
                }
                .tag(Tab.shoppingList)
            
            Text("Favourites Page")
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
                .tag(Tab.favourites)
            
            Text("Settings Page")
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    static var previews: some View {
        Group {
            HomeScreen()
                .environmentObject(modelData)
        }
    }
}
