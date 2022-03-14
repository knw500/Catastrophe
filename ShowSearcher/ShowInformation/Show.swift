//
//  Show.swift
//  ShowSearcher
//
//
//

import Foundation

struct Show: Decodable {
    
    let id: Int
    let showName: String
    let premiered: String
    let originalImageUrl: String
    
    init(id: Int, name: String, premiered: String, originalImageUrl: String) {
        self.id = id
        self.showName = name
        self.premiered = premiered
        self.originalImageUrl = originalImageUrl
    }
}

