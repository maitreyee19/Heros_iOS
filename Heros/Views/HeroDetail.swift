//
//  HeroDetail.swift
//  Heros
//
//  Created by bhabani das on 1/1/21.
//

import Foundation
import SwiftUI


struct HeroDetailView: View {
    @EnvironmentObject var heroData: ModelData
    var hero: Hero
    
    
    var heroIndex: Int {
        heroData.heros.firstIndex(where: { $0.id == hero.id })!
    }
    var body: some View {
        VStack {
            CircleImage(image: hero.image);
            ScrollView() {
//                Text(hero.name)
//                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//                    .foregroundColor(/*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/)
                HStack {
                    Text(hero.name)
                        .font(.title)
                        .foregroundColor(.primary)
                    FavoriteButton(isSet: $heroData.heros[heroIndex].isFavorite)
                }
                HStack {
                    Text(hero.story)
                    Spacer()
                    Text(hero.channel)
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
                Divider()
                Text("About \(hero.name)")
                    .font(.title2)
                Text(hero.description)
            }
            .padding()
        }
        .navigationTitle(hero.name)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct HeroDetailView_Previews: PreviewProvider {
    static let heroData = ModelData()
    static var previews: some View {
        HeroDetailView(hero: ModelData().heros[0])
            .environmentObject(heroData)
    }
}
