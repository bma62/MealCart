//
//  UserProfile.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-01.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

// more profile settings can be added later
struct UserProfile: Codable {
    var uid: String
    var email: String
    
}

class UserProfileViewModel: ObservableObject {
    // connect to Firestore
    private var db = Firestore.firestore()
    
    func createProfile(profile: UserProfile, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
        do {
            // create a new document under the users collection
            let _ = try db.collection("users").document(profile.uid).setData(from: profile)
            completion(profile, nil)
        } catch let error {
            print("Error writing to Firestore: \(error)")
            completion(nil, error)
        }
    }
    
    func fetchProfile(userId: String, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
        // retrieve user profile from Firestore
        db.collection("users").document(userId).getDocument { (snapshot, error) in
              let profile = try? snapshot?.data(as: UserProfile.self)
              completion(profile, error)
            }
    }
}
