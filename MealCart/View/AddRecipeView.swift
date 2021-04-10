//
//  AddRecipeView.swift
//  MealCart
//
//  Created by Boyi Ma on 2021-04-09.
//

// A view for the user to add recipes from URL
// Example: https://tasty.co/recipe/pizza-dough
import SwiftUI

struct AddRecipeView: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var mealPlanViewModel:FirestoreMealPlanViewModel
    
    @Binding var showInputField: Bool
    @State var showExtractionError = false
    @State private var addedRecipes = [Recipe]()
    @State var inputURL = ""
    
    var body: some View {
        NavigationView {
            
            // List of added recipes
            List {
                ForEach(addedRecipes) { recipe in
                    NavigationLink(
                        destination: RecipeDetail(recipe: recipe, showFavouriteButton: false, isFavourite: .constant(false)),
                        label: {
                            AddedMealRow(recipe: recipe)
                        })
                }
                .onDelete(perform: { indexSet in
                    addedRecipes.remove(atOffsets: indexSet)
                })
            }
            .listStyle(PlainListStyle())
            
            .onChange(of: showInputField, perform: { newValue in
                if newValue {
                    alertView()
                }
            })
            
            .navigationTitle("Add Recipes")
            .navigationBarItems(trailing:
                                    Button(action: {
                                        showInputField = true
                                    }, label: {
                                        Image(systemName: "plus")
                                    })
            )
            
            //Alert when extract is not successful
            .alert(isPresented: $showExtractionError, content: {
                Alert(title: Text("Extraction Failed"), message: Text("Source format not compatible"), dismissButton: .default(Text("OK"), action: {
                    showExtractionError = false
                }))
            })
        }
        
    }
    
    // The alert view asking for recipe URL
    func alertView() {
        
        let alert = UIAlertController(title: "Enter Recipe URL", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (recipeURL) in
            
        }
        
        let extractButton = UIAlertAction(title: "Extract", style: .default) { (_) in
            // Read input and send to API
            inputURL = alert.textFields![0].text!
            if inputURL != "" {
                SpoonacularAPI().extractRecipeFromWebsite(url: inputURL) { (recipe, error) in
                    // Test if the extraction was successful
                    if let recipe = recipe {
                        addedRecipes.append(recipe)
                        mealPlanViewModel.addRecipeToMealPlan(recipe: recipe, userId: session.session!.uid)
                    } else {
                        showExtractionError = true
                    }
                }
            }
            showInputField = false
        }
        
        // On cancel, dismiss the alert view
        let cancelButton = UIAlertAction(title: "Cancel", style: .destructive) { (_) in
            showInputField = false
        }
        
        // Add into alertView
        alert.addAction(cancelButton)
        alert.addAction(extractButton)
        
        // Present the alertView
        UIApplication.shared.windows.first?.rootViewController?.present(alert, animated: true, completion: {
            
        })
    }
}

struct AddRecipeView_Previews: PreviewProvider {
    @State static var showInputField = false
    
    static var previews: some View {
        AddRecipeView(showInputField: $showInputField)
            .environmentObject(FirestoreMealPlanViewModel())
    }
}
