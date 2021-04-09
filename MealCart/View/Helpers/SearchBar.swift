//
//  SearchBar.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-08.
//

// The search field used in NewMealPlan view
import SwiftUI

struct SearchBar: View {
    
    @Binding var searchText: String // The inputs search text
    @Binding var sendSearch: Bool // When to send search text to query 
    @State private var showCancelButton = false
    
    var body: some View {
        
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $searchText, onEditingChanged: { isEditing in
                    self.showCancelButton = isEditing
                }, onCommit: {
                    // If the user pressed return on keyboard and the text is not empty, send query
                    if searchText != "" {
                        sendSearch = true
                    }
                })
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .foregroundColor(.primary)
                
                // The clear x button
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(searchText == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            if showCancelButton  {
                Button("Cancel") {
                    hideKeyboard()
                    self.searchText = ""
                    self.showCancelButton = false
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
        .navigationBarHidden(showCancelButton) // Hide navigation bar when typing
    }
}

struct SearchBar_Previews: PreviewProvider {
    @State static var sendSearch = true
    @State static var text = ""
    
    static var previews: some View {
        SearchBar(searchText: $text, sendSearch: $sendSearch)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
