//
//  HeroRowList.swift
//  Heros
//
//  Created by bhabani das on 1/1/21.
//

import SwiftUI

struct HeroList: View {
    @EnvironmentObject var heroData: ModelData
    @State private var showFavoritesOnly = false
    
    var filteredHeros: [Hero] {
        heroData.heros.filter { hero in
            (!showFavoritesOnly || hero.isFavorite)
        }
    }
    
    var body: some View {
        NavigationView {
            List{
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favorites only")
                }
                
                ForEach(filteredHeros) { hero in
                    NavigationLink(destination: HeroDetailView(hero: hero)) {
                        HeroRow(hero: hero)
                    }
                }
            }
            .navigationTitle("Your Heros")
        }
        
        
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        HeroList()
            .environmentObject(ModelData())
    }
}
