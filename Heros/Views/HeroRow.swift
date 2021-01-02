//
//  HeroRow.swift
//  Heros
//
//  Created by bhabani das on 1/1/21.
//

import Foundation
import SwiftUI

struct HeroRow: View {
    var hero: Hero

    var body: some View {
        HStack {
            hero.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(hero.name)
            Spacer()
            if hero.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        HeroRow(hero: ModelData().heros[0])
    }
}
