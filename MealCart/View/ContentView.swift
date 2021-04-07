//
//  ContentView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-28.
//

/*
 A connecting view to decide which view the user sees upon opening the app
 */
import SwiftUI

struct ContentView: View {
    @ObservedObject private var session = SessionStore()
    @ObservedObject private var mealPlanViewModel = FirestoreMealPlanViewModel()
    
    func getUser() {
        session.listen()
    }
    
    var body: some View {
        Group {
            if (session.session != nil) {
                HomeScreen()
                    .environmentObject(session)
                    .environmentObject(mealPlanViewModel)
            } else {
                LogInView()
                    .environmentObject(session)
                    .environmentObject(mealPlanViewModel)
            }
        }.onAppear(perform: {
            getUser()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
