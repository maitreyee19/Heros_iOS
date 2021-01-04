//
//  ContentView.swift
//  Heros
//
//  Created by bhabani das on 12/31/20.
//

import SwiftUI

struct ContentView
: View {
    
    @State private var selection:Tab = Tab.featured
    
    enum  Tab {
        case featured
        case list
        case photo
    }
    
    var body: some View {
        
        TabView(selection: $selection){
            CategoryHome().tabItem { Label("Featured",systemImage:"star") }.tag(Tab.featured)
            HeroList().tabItem { Label("List",systemImage : "list.bullet") }.tag(Tab.list)
//            CameraView().tabItem { Label("Photo",systemImage : "camera.on.rectangle").tag(Tab.photo) }
            
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
