//
//  OrderHistoryView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-12.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct OrderHistoryView: View {
    @EnvironmentObject var orderViewModel: FirestoreOrderViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(orderViewModel.order) { order in
                    HStack {
                        if let createdTime = order.orderCreatedTime {
                            Text("\(dateFormatter(from:createdTime.dateValue()))")
                            Spacer()
                            Text("$\(formatNumber(from: order.orderAmount))")
                        }
                    }
                }
            }
            .navigationTitle("Order History")
        }
    }
}

func dateFormatter(from date: Date) -> String {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
    
    return dateFormatterGet.string(from: date)
}

struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
            .environmentObject(FirestoreOrderViewModel())
    }
}
