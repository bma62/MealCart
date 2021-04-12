//
//  FirestoreOrder.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-12.
//

/*
 A struct mapping to orders in Firestore
 */

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// Document of an order
struct FirestoreOrder: Codable {
    @DocumentID var id = UUID().uuidString // Get a uuid as document name
    var userId: String
    var driverId: String?            // Driver app will fill this in when a driver takes order
    var storeName: String            // From store API
    var storeAddress: String         // From store APT
    var orderItems: [OrderItem]      // Generate from shopping list items
    var orderAmount: Double          // From store API
    var orderStatus: String          // Driver app will update this when taking and completing orders
    @ServerTimestamp var orderCreatedTime: Timestamp? // Let Firestore write server time to each document for ordering
    var orderCompletedTime: Timestamp? // Driver app will fill this in when completing order
    
}

struct OrderItem: Codable {
    var amount: Double
    var unit: String
    var name: String
}

class FirestoreOrderViewModel: ObservableObject {
    
//    @Published var order = [FirestoreOrder]()

    private var db = Firestore.firestore()

    func placeOrder(userId: String, shoppingListItems: [FirestoreShoppingListItem]) {
        
        // Generate order items
        var orderItems = [OrderItem]()
        shoppingListItems.forEach { (shoppingListItem) in
            orderItems.append(OrderItem(amount: shoppingListItem.amount, unit: shoppingListItem.unit, name: shoppingListItem.name))
        }
        
        var orderAmount: Double = 0;
        orderItems.forEach { (item) in
            // Call getPrice and add to orderAmount
        }
        
        // Call store API to get store name and address
        var storeName = "Test Store", storeAddress = "Test Address"
        
        let newOrder = FirestoreOrder(userId: userId, storeName: storeName, storeAddress: storeAddress, orderItems: orderItems, orderAmount: orderAmount, orderStatus: "Order Placed")
        
        addOrder(order: newOrder)
    }
    
    // Add to database
    func addOrder(order: FirestoreOrder) {
        do {
            let _ = try db.collection("orders").addDocument(from: order)
        }
        catch {
            fatalError("Unable to encode task: \(error.localizedDescription).")
        }
    }
}
