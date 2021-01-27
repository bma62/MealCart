//
//  SessionStore.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-01-26.
//

import SwiftUI
import Firebase
import Combine

// this class handles user sessions
class SessionStore: ObservableObject {
    
    // MARK: Properties
    
    var didChange = PassthroughSubject<SessionStore, Never>()
    
    // Right after the session is updated, send signal to downstream subscribers as well
    @Published var session: User? {
        didSet {
            self.didChange.send(self)
        }
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    
    // MARK: Handler Functions
    
    /// Monitors authentication state changes
    func listen() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            // check if user is nil
            if let user = user {
                // if we have a user, create a new user model
                print("Got user: \(user)")
                self.session = User(uid: user.uid, email: user.email, displayName: user.displayName)
            }
            else {
                // if we don't have a user, set session to nil
                self.session = nil
            }
        })
    }
    
    // Stop listening to auth change handler
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        // Clean up
        unbind()
    }
    
    // MARK: Authentication Functions
    
    // After the function has completed, get the auth result
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        // Call the handler when the authentication has been done
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
        } catch {
            fatalError("Error loging out")
        }
    }
}
