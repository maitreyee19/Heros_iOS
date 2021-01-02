//
//  ContentView.swift
//  Heros
//
//  Created by bhabani das on 12/31/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HeroList();
       
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
