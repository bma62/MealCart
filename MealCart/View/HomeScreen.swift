//
//  ContentView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-05.
//

/*
 Homescreen of the app
 */
import SwiftUI

struct HomeScreen: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var mealPlanViewModel: FirestoreMealPlanViewModel
    
    // Enumeration holding the four tabs
    enum Tab {
        case mealPan
        case shoppingList
        case favourites
        case settings
    }
    
    var body: some View {
        TabView {
            MealPlanHome()
                .tabItem {
                    Label("Meal Plan", systemImage: "calendar")
                }
                .tag(Tab.mealPan)
            
            Text("Shopping List Page")
                .tabItem {
                    Label("Shopping List", systemImage: "list.bullet")
                }
                .tag(Tab.shoppingList)
            
            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "heart.fill")
                }
                .tag(Tab.favourites)
            
            // in case a user doesn't have profile, show some default contents
            SettingsView(userProfile: session.profile ?? UserProfile(uid: "TEST1234", email: "test@gmail.com"))
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .onAppear(){
            // Fetch the user's stored meal plans and subscribe to updaes
            mealPlanViewModel.fetchMealPlan(userId: session.profile!.uid)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static let session = SessionStore()
    static let mealPlanViewModel = FirestoreMealPlanViewModel()
    
    static var previews: some View {
        Group {
            HomeScreen()
                .environmentObject(session)
                .environmentObject(mealPlanViewModel)
        }
    }
}
