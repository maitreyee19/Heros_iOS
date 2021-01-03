//
//  CategoryRow.swift
//  Heros
//
//  Created by bhabani das on 1/2/21.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    var items: [Hero]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(items) { hero in
                        NavigationLink(destination: HeroDetailView(hero: hero)){
                            CategoryItem(hero: hero)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    
    static var heros = ModelData().heros
    
    static var previews: some View {
        CategoryRow(
            categoryName: heros[0].category.rawValue,
            items: Array(heros.prefix(4))
        )
    }
}
