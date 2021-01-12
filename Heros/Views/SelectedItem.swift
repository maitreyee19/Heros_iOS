//
//  SelectedItem.swift
//  Heros
//
//  Created by bhabani das on 1/11/21.
//

import SwiftUI

struct SelectedItem: View {
    
    @EnvironmentObject var heroData: ModelData
    var heroName: String
    var image = UIImage(systemName:"arrowshape.zigzag.right.fill")!
    
    var hero: Hero {
        let heros:Array<Hero>  = heroData.heros.filter({ $0.name == heroName })
        if(heros.count > 0 ) {
            return heros[0]
        }else{
            return heroData.heros[0]
        }
    }
    var body: some View {
        HStack{
            Image(uiImage: image)
            CategoryItem(hero: hero)
        }
    }
}

struct SelectedItem_Previews: PreviewProvider {
    static let heroData = ModelData()
    static var previews: some View {
        SelectedItem(heroName: "Elsa")
            .environmentObject(heroData)
    }
}
