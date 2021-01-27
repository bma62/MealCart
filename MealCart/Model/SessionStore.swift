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
    var didChange = PassthroughSubject<SessionStore, Never>()
    
    @Published var session: User? {
        didSet {
            self.didChange.send(self)
        }
    }
    
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen() {
        <#function body#>
    }
}
