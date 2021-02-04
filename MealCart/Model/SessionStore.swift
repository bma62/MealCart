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
    
    @Published var profile: UserProfile?
    
    private var profileViewModel = UserProfileViewModel()
    
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
    
    func signUp(email: String, password: String, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error signing up \(error)")
                completion(nil, error)
                return
            }
            
            guard let user = result?.user else { return }
            print("User \(user.uid) successfully signed up.")
            
            let userProfile = UserProfile(uid: user.uid, email: email)
            
            self.profileViewModel.createProfile(profile: userProfile) { (profile, error) in
                if let error = error {
                    print("Error creating user profile in Firestore \(error)")
                    completion(nil, error)
                    return
                }
                self.profile = profile
                completion(profile, nil)
            }
        }
    }

    func logIn(email: String, password: String, completion: @escaping (_ profile: UserProfile?, _ error: Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("Error loging in \(error)")
                completion(nil, error)
                return
            }
            
            guard let user = result?.user else { return }
            print("User \(user.uid) successfully logged in.")
            
            self.profileViewModel.fetchProfile(userId: user.uid) { (profile, error) in
                if let error = error {
                    print("Error fetching user profile from Firestore \(error)")
                    completion(nil, error)
                    return
                }
                
                self.profile = profile
                completion(profile, nil)
            }
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
            self.session = nil
            self.profile = nil
        } catch {
            print("Error loging out \(error)")
        }
    }
}
