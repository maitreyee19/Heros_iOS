//
//  Hero.swift
//  Heros
//
//  Created by bhabani das on 1/1/21.
//

import Foundation
import SwiftUI

struct Hero: Hashable, Codable ,Identifiable{
    var id: Int
    var name: String
    var story: String
    var channel: String
    var description: String
    var isFavorite: Bool
    
    var category: Category
    enum Category: String, CaseIterable, Codable {
        case superHero = "Super Hero"
        case educational = "Educational"
        case princess = "Princess"
    }
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
}
