//
//  ContentView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-28.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    
    func getUser() {
        session.listen()
    }
     
    var body: some View {
        Group {
            if (session.session != nil) {
                HomeScreen()
            } else {
                LogInView()
            }
        }.onAppear(perform: {
            getUser()
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
    }
}
