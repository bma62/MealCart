//
//  SettingsView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-04.
//

/*
 The view to show the user's profile settings
 */
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var session: SessionStore
    var userProfile: UserProfile
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    Text("User ID: \(userProfile.uid)")
                    Text("Email: \(userProfile.email)")
                    Text("First Name: \(userProfile.firstName)")
                    Text("Last Name: \(userProfile.lastName)")
                    Text("Address: \(userProfile.address)")
                }
                
                Section (header: Text("Order History")) {
                    NavigationLink(
                        destination: OrderHistoryView(),
                        label: {
                            Text("View Orders")
                        })
                }
                
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
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static let session = SessionStore()
    
    static var previews: some View {
        NavigationView {
            SettingsView(userProfile: UserProfile(uid: "TEST1234", email: "test@gmail.com", firstName: "Test", lastName: "User", address: ""))
                .environmentObject(session)
        }
    }
}
