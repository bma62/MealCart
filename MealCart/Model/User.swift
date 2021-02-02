//
//  User.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-26.
//

import Foundation

/*
 This struct conforms to Firebase Authentication
 */
struct User {
    var uid: String
    var email: String?
    var displayName: String?
    
    init(uid: String, email: String?, displayName: String?) {
        self.uid = uid
        self.email = email
        self.displayName = displayName
    }
}
