//
//  Constants.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-03-16.
//

/*
 A file holding all reusable constants for consistency throughout views
 */

import Foundation
import SwiftUI

struct Constants {
    
    struct viewLayout {
        
        static let twoColumnGrid = [
            GridItem(.flexible(minimum: 50, maximum: 200), spacing: 16, alignment: .top),
            GridItem(.flexible(minimum: 50, maximum: 200))
        ]
    }
}
