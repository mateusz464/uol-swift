//
//  DataModel.swift
//  New Brighton Murals
//
//  Created by Mateusz Golebiowski on 29/11/2022.
//

import Foundation

struct image: Codable {
    let id: String
    let filename: String
}

struct singleMural: Codable {
    let id: String
    let title: String?
    let artist: String?
    let info: String?
    let thumbnail: String?
    let lat: String?
    let lon: String?
    let enabled: String
    let lastModified: String
    let images: [image]
}

struct muralsData: Codable {
    var newbrighton_murals: [singleMural]
}
