//
//  DataModel.swift
//  New Brighton Murals
//
//  Created by Mateusz Golebiowski on 29/11/2022.
//

import Foundation

struct image {
    let id: Int
    let filename: String
}

struct muralsData {
    let id: String
    let title: String?
    let artist: String?
    let info: String?
    let thumbnail: String?
    let lat: Double?
    let lon: Double?
    let enabled: String
    let lastModified: Date
    let images: [image]
}
