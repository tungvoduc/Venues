//
//  APIConfiguration.swift
//  Nearby
//
//  Created by Tung Vo on 10.6.2019.
//  Copyright © 2019 Tung Vo. All rights reserved.
//

import Foundation

// This can be extended to add more configuration
final class APIConfiguration {
    
    let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
}

extension APIConfiguration {
    static let wolt = APIConfiguration(baseURL: "https://restaurant-api.wolt.fi")
}
