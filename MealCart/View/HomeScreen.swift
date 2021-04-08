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
            
            ShoppingListView()
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
            SettingsView(userProfile: session.profile ?? UserProfile(uid: "TEST1234", email: "", firstName: "", lastName: "", address: ""))
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(Tab.settings)
        }
        .onAppear(){
            let userId = session.session!.uid
            // Fetch the user's stored meal plans and favourites and subscribe to updaes
            mealPlanViewModel.fetchMealPlan(userId: userId)
            mealPlanViewModel.fetchFavouriteMealPlan(userId: userId)
            mealPlanViewModel.fetchShoppingList(userId: userId)
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
