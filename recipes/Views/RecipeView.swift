//
//  SwiftUIView.swift
//  recipes
//
//  Created by Gemma Emery on 2/7/24.
//

import SwiftUI
import CoreData

struct RecipeView: View {
    @FetchRequest(fetchRequest: Recipe.fetchRequest()) private var recipes: FetchedResults<Recipe>
    private var id: Int64
    
    private var recipe : Recipe {
        get { recipes.first! }
    }
    
    @State private var selectedTab: Int32 = 0
    let minDragTranslationForSwipe: CGFloat = 50
    
    init(id: Int64) {
        self.id = id
        _recipes = FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "id = %@", id.description), animation: .default)
    }
    
    
    
    var body: some View {
        let img : UIImage = UIImage(data: recipes.first?.image ?? Data()) ?? UIImage(systemName: "plus.circle")!
        let name = recipes.first?.title ?? "Data loading..."
        let numTabs = recipe.steps!.count
        
        
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 2)
                .foregroundColor(.blue)
                .padding([.leading, .bottom, .trailing], 10)
            VStack {
                Image(uiImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .padding(15)
                    .shadow(color: .black, radius: 10)
                    
                Text("\(name)").font(.system(size: 24, weight: .bold, design: .rounded)).padding(.horizontal)
                
                TabView(selection: $selectedTab) {
                    let stepsArr = recipe.steps!.array as! [Step]
                    ForEach(stepsArr) { step in
                        StepView(parentNumTabs: numTabs, parentSelectedTab: $selectedTab, content: step)
                            .tabItem {
                                Image(systemName: "\(step.number).circle")
//                                Text("\(step.number.description)").font(.title)
                            }
                            .tag(step.number - 1)
                            .highPriorityGesture(DragGesture().onEnded({
                                self.handleSwipe(translation: $0.translation.width, numTabs: numTabs)
                            }))
                    }
                }.frame(maxHeight: .infinity).padding(5)
            }.padding(10)
        }.padding([.leading, .bottom, .trailing], 10)
    }
    
    private func handleSwipe(translation: CGFloat, numTabs: Int) {
        print("handling swipe! horizontal translation was \(translation)")
            if translation > minDragTranslationForSwipe && selectedTab > 0 {
                selectedTab -= 1
            } else  if translation < -minDragTranslationForSwipe && selectedTab < numTabs-1 {
                selectedTab += 1
            }
        }
    
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(id: 10)
    }
}
