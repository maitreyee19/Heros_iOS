//
//  CategoryHome.swift
//  Heros
//
//  Created by bhabani das on 1/2/21.
//

import SwiftUI


struct CategoryHome: View {
    @EnvironmentObject var modelData: ModelData
    
    var body: some View {
        VStack{
            
            NavigationView {
                VStack{
                    CameraView()
                    List {
                        ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                            CategoryRow(categoryName: key, items: modelData.categories[key]!)
                        }
                    }
                }
                .navigationTitle("Kids Characters")
            }
        }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
            .environmentObject(ModelData())
    }
}
