//
//  StepView.swift
//  recipes
//
//  Created by Gemma Emery on 2/7/24.
//

import SwiftUI

struct StepView: View {
    var parentNumTabs: Int
    @Binding var parentSelectedTab: Int32
    var content: Step
    var body: some View {
        ZStack {
            ScrollView([.vertical]){
                Text(content.body!).font(.body)
                
                
            }.padding([.top, .leading, .trailing], 15.0).frame(alignment: .topTrailing)
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 3)
                    .padding(10)
                    .foregroundColor(.green)
                    .frame(maxHeight: .infinity)
                content.number < parentNumTabs ? Button("Next step >", action: {
                    parentSelectedTab += 1
                }).buttonStyle(.bordered)
                : Button("<< to Begin", action: {
                    parentSelectedTab = 0
                }).buttonStyle(.bordered)
                    
            }
            
        }.padding(5)
        
    }
}


//struct StepView_Previews: PreviewProvider {
//    static var previews: some View {
//        StepView(parentSelectedTab: Binding<Int32>, content: "content")
//    }
//}
