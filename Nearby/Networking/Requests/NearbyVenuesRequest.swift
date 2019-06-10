//
//  NearbyVenues.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import Foundation
import CoreLocation

struct NearbyVenuesRequest: APIRequestProtocol {
    
    typealias ResquestDataType = CLLocationCoordinate2D
    
    typealias ResponseDataType = [Venue]
    
    let configuration: APIConfiguration
    
    init(configuration: APIConfiguration = APIConfiguration.wolt) {
        self.configuration = configuration
    }
    
    
    /// Create venues list request
    /// - parameters:
    /// - location: location where venues are close to.
    /// - returns: An instance of URLRequest
    func createRequest(_ location: CLLocationCoordinate2D) throws -> URLRequest {
        if let url = URL(string: configuration.baseURL), var components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
            components.path = "/v3/venues"
            components.queryItems = [
                URLQueryItem(name: "lat", value: String(location.latitude)),
                URLQueryItem(name: "lon", value: String(location.longitude))
            ]
            return URLRequest(url: components.url!)
        } else {
            throw RequestError.invalidURL
        }
    }
    
    func parseResponse(_ data: Data) throws -> [Venue] {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
            let venuesJSON = json["results"] as? [[String : Any]] else {
            throw RequestError.incorrectDataFormat
        }
        
        return venuesJSON.compactMap(Venue.init)
    }
}
