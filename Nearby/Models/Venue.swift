//
//  Venue.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import Foundation

// Cannot use Codable because of complexity
struct Venue: CustomStringConvertible {
    
    let id: String
    let name: String?
    let imageURL: URL?
    let shortDescription: String?
    
    var favorited: Bool = false
    
    init?(json: [String: Any]) {
        guard let idJSON = json["id"] as? [String: String], let id = idJSON["$oid"] else {
            return nil
        }
        
        self.id = id
        
        // shortDescription
        if let descriptionJSON = json["description"] as? [[String: String]], let description = descriptionJSON.first?["value"] {
            shortDescription = description
        } else {
            shortDescription = nil
        }
        
        // name
        if let nameJSON = json["name"] as? [[String: String]], let name = nameJSON.first?["value"] {
            self.name = name
        } else {
            name = nil
        }
        
        // imageURL
        if let descriptionJSON = json["listimage"] as? String {
            imageURL = URL(string: descriptionJSON)
        } else {
            imageURL = nil
        }
    }
    
    var description: String {
        return "id: \(id), name: \(String(describing: name)), description: \(String(describing: shortDescription)), imageURL: \(String(describing: imageURL))"
    }
    
}
