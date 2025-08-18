//
//  Photo.swift
//  SeSACRxThreads
//
//  Created by Jack on 8/18/25.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let weight: Int?
    let height: Int?
    let urls: ImageURL
}

struct ImageURL: Decodable {
    let regular: String
}
