//
//  FavouritesView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-02-05.
//

/*
  I think it might be easier to do this after the meal plan view and data model is up and running
 */

import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var session: SessionStore

    var recipesId : [Int]?
    
    var body: some View {
        Text("Favourites Page")
    }
}

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
