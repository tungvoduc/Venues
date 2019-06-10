//
//  VenuesController.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import Foundation

/// Model controller
/// Used to perform certain task on Venue object.
/// Currently favorite/unfavorite a venue (but possibly sending api request)
protocol VenuesControlling {
    func updateVenue(_ venue: Venue, with isFavorite: Bool)
    func isVenueFavorited(_ venue: Venue) -> Bool
}

final class VenuesController: VenuesControlling {
    var userDefaults: UserDefaults
    
    private var favoriteVenuesKey: String { return "VenuesController.Venues" }
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    func updateVenue(_ venue: Venue, with isFavorite: Bool) {
        var venues = favoriteVenues()
        
        if !venues.contains(venue.id), isFavorite {
            venues.append(venue.id)
            update(withVenues: venues)
        } else if venues.contains(venue.id), !isFavorite {
            venues.removeAll { $0 == venue.id }
            update(withVenues: venues)
        }
    }
    
    func isVenueFavorited(_ venue: Venue) -> Bool {
        let venues = favoriteVenues()
        return venues.contains(venue.id)
    }
    
    private func update(withVenues venues: [String]) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
            self.userDefaults.set(venues, forKey: self.favoriteVenuesKey)
            self.userDefaults.synchronize()
        }
    }
    
    private func favoriteVenues() -> [String] {
        return (userDefaults.value(forKey: favoriteVenuesKey) as? [String]) ?? []
    }
    
}
