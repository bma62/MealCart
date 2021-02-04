//
//  SettingsView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-04.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: SessionStore
    var userProfile: UserProfile
    
    var body: some View {
        Form {
            Text(userProfile.uid)
            Text(userProfile.email)
            Section {
                Button(action: session.logOut) {
                    HStack {
                        Spacer()
                        Text("Log Out")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }

        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let session = SessionStore()
    
    static var previews: some View {
        SettingsView(userProfile: UserProfile(uid: "TEST1234", email: "test@gmail.com"))
            .environmentObject(session)
    }
}
