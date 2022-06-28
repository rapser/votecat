//
//  Breed.swift
//  votacion
//
//  Created by miguel tomairo on 25/06/22.
//

import Foundation

// MARK: - Breed
struct Breed: Codable {
    var uuid: Int?
    var vote: Vote?
    var date: String?
    let weight: Weight?
    let id, name: String?
    let cfaURL: String?
    let vetstreetURL: String?
    let vcahospitalsURL: String?
    let temperament, origin, countryCodes, countryCode: String?
    let description, life_span: String?
    let indoor, lap: Int?
    let altNames: String?
    let adaptability, affectionLevel, childFriendly, dogFriendly: Int?
    let energyLevel, grooming, healthIssues, intelligence: Int?
    let sheddingLevel, socialNeeds, strangerFriendly, vocalisation: Int?
    let experimental, hairless, natural, rare: Int?
    let rex, suppressedTail, shortLegs: Int?
    let wikipediaURL: String?
    let hypoallergenic: Int?
    let referenceImageID: String?
    let image: Image?
}

typealias Breeds = [Breed]

// MARK: - Image
struct Image: Codable {
    let id: String?
    let width, height: Int?
    let url: String?
}

// MARK: - Weight
struct Weight: Codable {
    let imperial, metric: String?
}
