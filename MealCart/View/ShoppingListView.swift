//
//  ShoppingListView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-07.
//

import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var mealPlanViewModel : FirestoreMealPlanViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(mealPlanViewModel.shoppingList) { shoppingListItem in
                    Text("\(formatNumber(from: shoppingListItem.amount)) \(shoppingListItem.unit) \(shoppingListItem.name)")
                }
                .onDelete(perform: { indexSet in
                    let index = indexSet[indexSet.startIndex]
                    mealPlanViewModel.removeShoppingListItem(userId: session.profile!.uid, at: index)
                })
            }
            .overlay(
                Button(action: {
                    #warning("INTERACTION WITH GROCERY STORE API HERE")
                }) {
                    Text("Place Order")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 220, height: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom),
                alignment: .bottom)
            .navigationTitle("Shopping List")
            .toolbar {
                EditButton()
            }
        }
    }
}

// A number formatter to remove trailing zeros and keep a maximum of 2 decimal places
func formatNumber(from number: Double) -> String {
    let formatter = NumberFormatter()
    formatter.minimumIntegerDigits = 1
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    return formatter.string(from: NSNumber(value: number)) ?? "Error converting amount"
    
}

struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShoppingListView()
                .environmentObject(FirestoreMealPlanViewModel())
        }
    }
}
