//
//  HerosApp.swift
//  Heros
//
//  Created by bhabani das on 12/31/20.
//

import SwiftUI

@main
struct HerosApp: App {
    @StateObject private var heroData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(heroData)
        }
    }
}
