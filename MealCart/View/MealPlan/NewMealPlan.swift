//
//  NewMealPlan.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-08.
//

import SwiftUI

struct NewMealPlan: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Button("Dismiss"){
            presentationMode.wrappedValue.dismiss()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct NewMealPlan_Previews: PreviewProvider {
    static var previews: some View {
        NewMealPlan()
    }
}
