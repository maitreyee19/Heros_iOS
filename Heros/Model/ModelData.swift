//
//  ModelData.swift
//  Heros
//
//  Created by bhabani das on 1/1/21.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var heros: [Hero] = []
    
    let apiClient = APIClient()
    var cancellationToken: AnyCancellable?
    
    init(){
        print("api data going to be loaded")
        heros = load("landmarkData.json")
        
//        guard let components = URLComponents(url: URL(string: "https://heroapp.s3-us-west-1.amazonaws.com/heros.json")!, resolvingAgainstBaseURL: true)
//        else { fatalError("Couldn't create URLComponents") }
//        
//        
//        let request = URLRequest(url: components.url!)
//        cancellationToken = apiClient.run(request)
//            .map(\.value)
//            .sink(receiveCompletion: { _ in },
//                  receiveValue: {
//                    self.heros = $0
//                  })
    }
    
    var categories: [String: [Hero]] {
        Dictionary(
            grouping: heros,
            by: { $0.category.rawValue }
        )
    }
}





func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

