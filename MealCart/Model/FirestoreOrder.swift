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
struct FirestoreOrder: Codable, Identifiable, Hashable {
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

struct OrderItem: Codable, Hashable {
    var amount: Double
    var unit: String
    var name: String
}

// A struct of returned JSON structure from grocery store API
struct GroceryItem:Codable {
    var title: String
    var body: Double
}

struct StoreInfo:Codable {
    var name: String
    var address: String
}

class FirestoreOrderViewModel: ObservableObject {
    
    @Published var order = [FirestoreOrder]()
    
    private var db = Firestore.firestore()
    
    func fetchOrder(userId: String) {
        db.collection("orders")
            .whereField("userId", isEqualTo: userId)
            .order(by: "orderCreatedTime", descending: true)
            // Subscribe to updates at the server side
            .addSnapshotListener { querySnapshot, error in
                if let querySnapshot = querySnapshot {
                    self.order = querySnapshot.documents.compactMap { document -> FirestoreOrder? in
                        try? document.data(as: FirestoreOrder.self)
                    }
                }
            }
    }
    
    func placeOrder(userId: String, shoppingListItems: [FirestoreShoppingListItem]) -> Double {
        
        // Generate order items
        var orderItems = [OrderItem]()
        shoppingListItems.forEach { (shoppingListItem) in
            orderItems.append(OrderItem(amount: shoppingListItem.amount, unit: shoppingListItem.unit, name: shoppingListItem.name))
        }
        
        var orderAmount: Double = 0
        
        let sampleItems = ["Bananas", "Apples", "Oranges", "Sugar", "Salt", "Eggs", "Bell Pepper", "Butter", "Onions"]
        
        sampleItems.forEach { (item) in
            // Call getPrice and add to orderAmount
            getPrice(item: item) { (groceryItem, error) in
                // If we got the requested item
                if let groceryItem = groceryItem {
                    orderAmount += groceryItem.body
                    print(orderAmount)
                } else {
                    print(error!)
                }
            }
        }
        
        // Call store API to get store name and address
        var storeName = "Test Store", storeAddress = "Test Address"
        
        getInfo() { (storeInfo, error) in
            
            if let storeInfo = storeInfo{
                storeName = storeInfo.name
                print(storeName)
                storeAddress = storeInfo.address
                print(storeAddress)
                
                let newOrder = FirestoreOrder(userId: userId, storeName: storeName, storeAddress: storeAddress, orderItems: orderItems, orderAmount: orderAmount, orderStatus: "Order Placed")
                
                self.addOrder(order: newOrder)
                
            } else {
                print(error!)
            }
            
        }
        
        return orderAmount
        
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
    
    // On complete, return a grocery item or error
    func getPrice(item: String, completion: @escaping (GroceryItem?, Error?) -> Void){
        
        // Data to send
        let params = [
            "title": "Test",
            "body": item
        ]
        
        //URL to go to
        guard let url = URL(string: "http://localhost:3000/getPrice") else {
            fatalError("Error creating URL object")
        }
        
        //Set which data to send and other URL info
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        //Create the session
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Print in case of error
            if let error = error {
                print("The error was: \(error.localizedDescription)")
            } else {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(GroceryItem.self, from: data!)
                    DispatchQueue.main.async {
                        completion(decodedData, nil) // Extraction successful with no error
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            }
            
            //Start the session
        }
        .resume()
        
    }
    
    func getInfo( completion: @escaping (StoreInfo?, Error?) -> Void){
        
        // Data to send
        let params = [
            "title": "Test",
            
        ]
        
        //URL to go to
        guard let url = URL(string: "http://localhost:3000/getInfo") else {
            fatalError("Error creating URL object")
        }
        
        //Set which data to send and other URL info
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        
        //Create the session
        URLSession.shared.dataTask(with: request) { data, response, error in
            //Print in case of error
            if let error = error {
                print("The error was: \(error.localizedDescription)")
            } else {
                do {
                    let decoder = JSONDecoder()
                    let decodedData = try decoder.decode(StoreInfo.self, from: data!)
                    DispatchQueue.main.async {
                        completion(decodedData, nil) // Extraction successful with no error
                    }
                } catch {
                    print(error)
                    completion(nil, error)
                }
            }
            
            //Start the session
        }
        .resume()
        
    }
}
