//
//  CategoryItem.swift
//  Heros
//
//  Created by bhabani das on 1/2/21.
//

import SwiftUI

struct CategoryItem: View {
    var hero: Hero

    var body: some View {
        VStack(alignment: .leading) {
            hero.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(hero.name)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CategoryItem_Previews: PreviewProvider {
    static var previews: some View {
        CategoryItem(hero: ModelData().heros[0])
    }
}
