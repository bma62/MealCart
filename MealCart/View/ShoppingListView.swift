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
    @EnvironmentObject var orderViewModel : FirestoreOrderViewModel
    
    @State private var showConfirmation = false //Show alert when order is placed
    @State private var orderAmount: Double = 0
    @State private var confirmationText = ""
    
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
                    // Only trigger placing order if shopping list is not empty
                    if !mealPlanViewModel.shoppingList.isEmpty {
                        // Place order and show confirmation with order total
                        orderViewModel.placeOrder(userId: session.session!.uid, shoppingListItems: mealPlanViewModel.shoppingList) { (amount) in
                            orderAmount = amount
                            showConfirmation = true
                            mealPlanViewModel.removeShoppingList(userId: session.session!.uid, shouldRegenerateList: false) // Clear shopping list after placing an order
                        }
                    }
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
                alignment: .bottom
            )
            .navigationTitle("Shopping List")
            .toolbar {
                EditButton()
            }
            
            //Order confirmation alert
            .alert(isPresented: $showConfirmation, content: {
                Alert(title: Text("Order Placed"), message: Text("Order total: $\(formatNumber(from: orderAmount))"), dismissButton: .default(Text("OK"), action: {
                    showConfirmation = false
                }))
            })
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
